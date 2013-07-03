SFP Planner for Ruby
====================
- Author: Herry (herry13@gmail.com)
- Version: 0.0.1
- License: [BSD License](https://github.com/herry13/sfp-ruby/blob/master/LICENSE)

A Ruby gem that provides a Ruby interface to a planner that generates a plan as the solution of a planning problem specified in [SFP language](https://github.com/herry13/nuri/wiki/SFP-language).

Click [here](https://github.com/herry13/nuri/wiki/SFP-language), for more details about SFP language.

This is a spin-out project from [Nuri](https://github.com/herry13/nuri).


To install
----------

	$ gem install sfplanner


Requirements
------------
- Ruby (>= 1.8.7)
- Rubygems
	- sfp (>= 0.3.0)
	- antlr3
	- json


Supporting Platforms
--------------------
- Linux (x86)
- MacOS X

Tested on: MacOS X 10.8, Ubuntu 12.04, and Scientific Linux 6.


To use as a command line to solve a planning task
-------------------------------------------------
- solve a planning task, and then print a sequential plan (if found) in JSON

		$ sfplanner <sfp-file>

The planning task must be written in [SFP language](https://github.com/herry13/nuri/wiki/SFP-language).


To generate a parallel (partial-order) plan
-------------------------------------------
- use option **--parallel** to generate a partial order plan

		$ sfplanner --parallel <sfp-file>


To use as Ruby library
----------------------
- include file *sfplanner* library in your codes:

		require 'sfplanner'

- to parse an SFP file: create a Sfp::Parser object, and then pass the content of the file:

		# Determine the home directory of your SFP file.
		home_dir = File.expand_path(File.dirname("my_file.sfp"))

		# Create Sfp::Parser object
		parser = Sfp::Parser.new({:home_dir => "./"})

		# Parse the file.
		parser.parse(File.read("my_file.sfp"))

		# Get the result in Hash data structure
		result = parser.root

- to solve a planning task: create a Sfp::Planner object, and then pass the file's path:

		# Create Sfp::Planner object.
		planner = Sfp::Planner.new

		# Solve a planning task written in "my_file.sfp", then print
		# the result in JSON.
		puts planner.solve({:file => "my_file.sfp", :json => true})



Example of Planning Problem
---------------------------
- Create file **types.sfp** to hold required schemas:

		schema Service {
			running is false
			procedure start {
				conditions {
					this.running is false
				}
				effects {
					this.running is true
				}
			}
			procedure stop {
				conditions {
					this.running is true
				}
				effects {
					this.running is false
				}
			}
		}
		schema Client {
			refer isref Service
			procedure redirect(s isref Service) {
				conditions { }
				effects {
					this.refer is s
				}
			}
		}

  In this file, we have two schemas that model our domain. First, schema
  **Service** with an attribute **running**, procedure **start** that
  changes **running**'s value from **false** to **true**, and procedure
  **stop** that changes **running**'s value from **true** to **false**.
  
  We also have schema **Client** with an attribute **refer**, which is
  a reference to an instance of **Service**. There is a procedure
  **redirect** that changes the value of **refer** with any instance if
  **Service**.

- Create file **task.sfp** to hold the task:

		include "types.sfp"
		
		initial state {
			a isa Service {
				running is true
			}

			b isa Service // with "running" is false

			pc isa Client {
				refer is a
			}
		}

		goal constraint {
			pc.refer is b
			a.running is false
		}

		global constraint {
			pc.refer.running is true
		}

  In this file, we specify a task where in the initial state of our domain,
  we have two services **a** and **b**, and a client **pc**. **a** is
  running, **b** is stopped, and **pc** is referring to **a**. We want to
  generate a workflow that achieves goal: **pc** is referring to **b**
  and **a** is stopped, and preserves global constraint: **pc** is always
  referring to a running service.

- To generate the workflow, we invoke **sfp** command with argument
  the path of the task file:

		$ sfp task.sfp

  Which will generate a workflow in JSON

		{
		  "type": "sequential",
		  "workflow": [
		    {
		      "name": "$.b.start",
		      "parameters": {
		      },
		      "condition": {
		        "$.b.running": false
		      },
		      "effect": {
		        "$.b.running": true
		      }
		    },
		    {
		      "name": "$.pc.redirect",
		      "parameters": {
		        "$.s": "$.b"
		      },
		      "condition": {
		      },
		      "effect": {
		        "$.pc.refer": "$.b"
		      }
		    },
		    {
		      "name": "$.a.stop",
		      "parameters": {
		      },
		      "condition": {
		        "$.a.running": true
		      },
		      "effect": {
		        "$.a.running": false
		      }
		    }
		  ],
		  "version": "1",
		  "total": 3
		}

  This workflow is sequential that has 3 procedures. If you executes
  the workflow in given order, it will achieves the goal state as well
  as perserves the global constraints during the execution.

- To generate and execute the plan using Bash framework, we invoke **sfp**
  command with an option *--solve-execute* and with an argument the path of
  the task file:

		$ sfp --solve-execute task.sfp

  It will generate and execute the plan by invoking the Bash scripts in
  the current directory (or as specified in environment variable SFP_HOME)
  in the following sequence:

		./modules/b/start
		./modules/pc/redirect "$.b"
		./modules/a/stop

- If you save the plan in a file e.g. **plan.json**, you could execute it
  later using option *--execute*

		$ sfp --execute plan.json

