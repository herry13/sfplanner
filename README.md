SFPlanner
=========
- Author: Herry (herry13@gmail.com)
- License: [BSD](https://github.com/herry13/sfp-ruby/blob/master/LICENSE)

[![Build Status Images](https://travis-ci.org/herry13/sfplanner.png)](https://travis-ci.org/herry13/sfplanner.png)
[![Gem Version](https://badge.fury.io/rb/sfplanner.png)](http://badge.fury.io/rb/sfplanner)

A Ruby script and library of SFP planner, which solves a planning task written in [SFP language](https://github.com/herry13/nuri/wiki/SFP-language).

Click [here](https://github.com/herry13/nuri/wiki/SFP-language), for more details about SFP language.

This is a spin-out project from [Nuri](https://github.com/herry13/nuri).


Features
--------
- Automatically generating a sequential or partial-order (parallel) plan.
- Use JSON as the standard format of the plan.
- Generate an image file that illustrates the graph of the plan.


To install
----------

	$ gem install sfplanner


Requirements
------------
- Ruby (>= 1.8.7)
- Graphviz
- Rubygems
	- sfp (>= 0.3.0)

Tested on:
- Ubuntu 12.04
- Debian Squeeze
- Scientific Linux 6
- MacOS X 10.8


To use as a command line
------------------------
- solve a planning task, and then print the output in JSON

		$ sfplanner <sfp-task-file>


To use as Ruby library
----------------------
- parse an SFP file, and then generate the plan (if found) in Hash:

	```ruby
	# include sfplanner library
	require 'sfplanner'

	# solve and return the plan in Hash
	planner.solve({:file => file_path})
	```

- parse an SFP file, and then generate the plan in JSON:

	```ruby
	# include sfplanner library
	require 'sfplanner'

	# solve and return the plan in Hash
	planner.solve({:file => file_path, :json => true})
	```


Example of Planning Task
------------------------
- Create file **types.sfp** to hold required schemas:

	```javascript
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
	```

  In this file, we have two schemas that model our domain. First, schema
  **Service** with an attribute **running**, procedure **start** that
  changes **running**'s value from **false** to **true**, and procedure
  **stop** that changes **running**'s value from **true** to **false**.
  
  We also have schema **Client** with an attribute **refer**, which is
  a reference to an instance of **Service**. There is a procedure
  **redirect** that changes the value of **refer** with any instance if
  **Service**.

- Create file **task.sfp** to hold the task:

	```javascript
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
	```

  In this file, we specify a task where in the initial state of our domain,
  we have two services **a** and **b**, and a client **pc**. **a** is
  running, **b** is stopped, and **pc** is referring to **a**. We want to
  generate a workflow that achieves goal: **pc** is referring to **b**
  and **a** is stopped, and preserves global constraint: **pc** is always
  referring to a running service.

- To generate the workflow, we invoke **sfp** command with argument
  the path of the task file:

		$ sfplanner task.sfp

  Which will generate a workflow in JSON

	```javascript
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
	```

  This workflow is sequential that has 3 procedures. If you executes
  the workflow in given order, it will achieves the goal state as well
  as perserves the global constraints during the execution.


Planner Options
---------------
You could set particular environment variable to change the planner settings:
- To activate debug-mode

	$ export SFPLANNER_DEBUG=1
	
  This will disable automated deletion of temporary files in temporary directory (/tmp/nuri_****/).

- To use multiple heuristic on finding the solution, and then pick the best result

	$ export SFPLANNER_MIXED_CONTINUE=1

- To set heuristics which are used in searching

	$ export SFPLANNER_MIXED_HEURISTICS=ff2,cea2


