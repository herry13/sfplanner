schema Service
schema Client {
	refer isref Service
	sub redirect ( s: Service) {
		effect {
			this.refer = s
		}
	}
}
