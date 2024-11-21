import yaml

class SubscriptionConfig:
    def __init__(self, config_path="data/subscriptions.yaml"):
        self.config_path = config_path

    def get_all(self):
        with open(self.config_path, "r") as file:
            return yaml.safe_load(file)

    def get_by_name(self, name):
        config = self.get_all()
        for subscription in config.get("subscriptions", []):
            if subscription["name"] == name:
                return subscription
        return None

    def update(self, new_config):
        with open(self.config_path, "w") as file:
            yaml.dump(new_config, file)
        return new_config
