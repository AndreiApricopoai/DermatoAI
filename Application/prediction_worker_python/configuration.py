import configparser


class Configuration:

    def __init__(self, file_path: str):
        self.file_path = file_path
        self.config = configparser.ConfigParser()
        self.config.read(file_path)

    def get_config(self):
        pass

    def __str__(self) -> str:
        return f'Configuration object for {self.file_path} file'
