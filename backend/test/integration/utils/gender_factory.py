from backend.models.gender_identity import GenderIdentity


class GenderFactory:
    def __init__(self):
        self.gender_identity_cache = {}

    def get_or_create_gender_identity(self, name):
        if name in self.gender_identity_cache:
            return self.gender_identity_cache[name]
        new_gender_identity = GenderIdentity(name=name)
        self.gender_identity_cache[name] = new_gender_identity
        return new_gender_identity

    def clean_cache(self):
        self.gender_identity_cache.clear()
