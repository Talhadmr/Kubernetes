
.PHONY: up clean re

up:
	@echo "Starting Vagrant machines..."
	vagrant up

clean:
	@echo "Halting Vagrant machines..."
	vagrant halt
	@echo "Destroying Vagrant machines without confirmation..."
	vagrant destroy -f
	@echo "Removing .vagrant directory..."
	rm -rf .vagrant

re:
	@echo "Rebooting Vagrant machines..."
	make clean
	make up
