.PHONY: up clean re deploy

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

deploy:
	@echo "Deploying applications using deploy.sh script..."
	sudo -E bash scripts/deploy.sh

clean-pods:
	@echo "Cleaning pods..."
	sudo kubectl delete pods --all

clean-deployments:
	@echo "Cleaning deployments..."
	sudo kubectl delete deployments --all

get-pods:
	@echo "Getting pods..."
	sudo kubectl get pods 


get-services:
	@echo "Getting services..."
	sudo kubectl get services 

