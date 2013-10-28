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
