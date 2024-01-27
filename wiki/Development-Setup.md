Please find instructions on how to best setup the development environment on a local machine.

# Backend
### Requirements
- python >=3.11
- docker (not necessary, if you want to use another database)

It would be preferred to run this python project in a linux environment (if on windows, use wsl - I've had some problems with some postgres packages on windows)

### Setup a python environment (recommended)
1. Setup a python virtual-env:
   ```bash
   python3 -m venv .venv
   ```
2. Activate the python virtual-env:
   ```bash
   source .venv/bin/activate
   ```
3. Install the required packages:
   ```bash
   pip install -r requirements.txt
   ```

### Start the database from the docker-compose file (you can use a different database of your own choice)
1. Change the permissions to the database script:
  ```bash
  chmod +x ci/compose/scripts/database-startup.sh
  ```
2. Start the database:
  ```bash
  docker-compose -f ci/compose/development.yaml up -d
  ```
3. Make sure the database is configured properly in the `backend/database.json` file (if you are using the database from the docker-compose suite, you don't have to change anything)

### Start the backend
```bash
PYTHONPATH=$PYTHONPATH:$PWD python backend/main.py --reload
```

You can also start the backend the old way as well:
```bash
uvicorn backend.main:app --reload
```

# Frontend

To begin with, make sure you have Flutter installed correctly by following the instructions in [this comprehensive video guide](https://www.youtube.com/watch?v=VFDbZk2xhO4&ab_channel=Codemy.com).

### Step 1: Navigate to Frontend Directory

Open a terminal window and navigate to the 'frontend/' directory of your project.

### Run the Frontend with Chrome 

Execute the following command to run the frontend using Chrome as the device:

```bash
flutter run lib/src/main.dart -d chrome
```

This will automatically open up a chrome window with the CustomLove App.

**Important:** In the actual release version CustomLove is only compatible with Google Chrome. Using other browsers could limit the functionality.

### Run the Frontend with Android Device

For starting the application on an emulated device you need to start the emulator. [Here](https://www.youtube.com/watch?v=03fmkz4Gz9s&ab_channel=ShanFix) is a guide how to install and run an emulator.

After starting the Android emulator you can check your devices with the following command:

```bash
flutter devices
```

Now you can start the flutter app on your emulator with:

```bash
flutter run lib/src/main.dart -d <YOUR_EMULATOR_ID>
```

The emulator id looks like this: emulator-5554.
This will automatically open the CustomLove App on your Android device.\
**Important:** Since we don't have a screen-size adaptive app yet, we use the emulated **Samsung Pixel 7 Pro.**


### Run Tests
To run all frontend tests change in the /frontend directory and run:

```bash
flutter test
```

This will execute all given frontend tests