from sklearn.linear_model import LogisticRegression
from datetime import date
import joblib
from io import BytesIO
from typing import List
from backend.models.user import User
from backend.datagenerator.data.features import interests_dict


class ExSys:
    """
    X_train: The features on which we train our model (in our case: all user features despite like/dislike)
    y_train: The target feature on which we train our model (in our case: like/dislike)
    X_predict: The features on which we want to make a decision (in our case: all user features despite like/dislike)
    y_predict: The decision (in our case: like/dislike)
    """
    def __init__(self, model):
        self.model = model

    # TODO Testing in comming Workflow
    def train_model(self, user_list: List[User], like_decisions: List[bool]):
        """
        Retrieves trainingsdata to train a model based on this. length(user_list)==length(like_decisions)
        param: user_list, list of user to train the model
        param: like_decisions, array of boolean which predict if the user liked(=1) or disliked(=0) the at the
        corresponding index
         return a model trained on the trainingsdata.
        """

        # Creates a logic regression model
        model = LogisticRegression(max_iter=1000)

        # Build input for model
        X_train, y_train = users_and_likes_to_x_train_y_train(user_list, like_decisions)

        # Train model
        model.fit(X_train, y_train)

        # set the model of the exsys instance
        self.model = model

        return model

    def train_model_with_fixed_training_data(self, X_train, y_train):
        """
        Retrieves trainingsdata to train a model based on this. length(user_list)==length(like_decisions)
        (Only relevant for our trainingsdata form data_generator.py
        param: user_list, list of user to train the model
        param: like_decisions, array of boolean which predict if the user liked(=1) or disliked(=0) the at the
        corresponding index
         return a model trained on the trainingsdata.
        """

        # Creates a logic regression model
        model = LogisticRegression(max_iter=1000)

        # Train model
        model.fit(X_train, y_train)

        # set the model of the exsys instance
        self.model = model

        return model

    # TODO Testing in comming Workflow
    def update_model(self, liked_user: List[User], viewed_user: List[User]):
        """
        Retrieves a model and trainingsdata to update the model with the data. length(user_list)==length(like_decisions)
        param: model, existing logic regression model
        param: liked_user, list of liked user to train the model
        param: viewed_user, list of viewed user to train the model
        corresponding index
        return the model updated with the trainingsdata.
        """
        user_list = liked_user + viewed_user
        liked_decisions = [1] * len(liked_user)
        viewed_decisions = [0] * len(viewed_user)
        like_decisions = liked_decisions + viewed_decisions

        # Build input for model
        X_train, y_train = users_and_likes_to_x_train_y_train(user_list, like_decisions)

        # Update existing model
        self.model.fit(X_train, y_train)

        return self.model

    def serialize_model(self):
        """
        Retrieves a LogicRegression model
        return a serialized object of the model to store in the database
        """
        # Create byte object
        bytes_object = BytesIO()
        # Dump model in byte object
        joblib.dump(self.model, bytes_object)
        # Get value of dump
        serialized_model = bytes_object.getvalue()

        return serialized_model

    def deserialize_and_set_model(self, serialized_model):
        """
        Retrieves a  serialized LogicRegression() model
        returns a LogicRegression() model read to use
        """

        # deserialize bytes object
        loaded_model = joblib.load(BytesIO(serialized_model))

        # set the model of the exsys instance
        self.model = loaded_model

        return self.model

    def predict(self, user_list):
        """
        Retrieves a list of users
        returns the user id of the user with the highest prediction and the corresponding probability .
        """
        # Create list with predictions
        y_predict = []
        highest_prediction = 0
        highest_predicted_user = 0

        for user in user_list:
            X_test = [user_to_x_predict(user)]
            probability = self.model.predict_proba(X_test)[0, 1]  # Probability of class "1" (liked)
            if probability > highest_prediction:
                highest_prediction = probability
                highest_predicted_user = user.id
            y_predict.append(probability)

        return highest_predicted_user, highest_prediction


def users_and_likes_to_x_train_y_train(user_list, like_decisions):
    """
    Calculates X_train and y_train for a given user list and the like decision on them
    param: user_list, a list of user recent swiped users
    param: like_decisions, a list with the decisions (like/dislike) on the users in user_list
    returns X_train, y_train
    """

    # Create training data
    X_train = []

    # Target Data
    y_train = like_decisions

    for user in user_list:
        # Add base user features
        inner_X_train = calculate_user_base_list(user)

        # Add users interests
        inner_X_train.extend(calculate_user_interests_list(user))

        X_train.append(inner_X_train)

    return X_train, y_train


def user_to_x_predict(user):
    """
    Calculates X_predict for a given user
    param: user
    returns X_predict
    """
    # Add base user features
    X_predict = calculate_user_base_list(user)

    # Add users interests
    X_predict.extend(calculate_user_interests_list(user))
    return X_predict


def calculate_user_interests_list(user):
    """
    Calculates the user interests vector
    param: user
    returns a list with values 0 or 1 at position x if the user has interest interest_dict[x] or not
    """
    user_interests_list = []
    for interest_string in interests_dict:
        interest = interests_dict.get(interest_string)
        count = 0
        for user_interest in user.interests:
            if interest.name == user_interest.name:
                count = count + 1
            else:
                continue
        user_interests_list.append(count)
    return user_interests_list


def calculate_user_base_list(user):
    """
    Calculates the user base vector
    param: user
    returns a list with numerical values for the users base features
    """
    # Mapping dictionary for encoding gender labels
    gender_mapping = {"man": 1, "woman": 2, "divers": 3}
    user_base_list = [user.get_age(), len(user.bio), gender_mapping.get(user.gender_identity.name)]
    return user_base_list





