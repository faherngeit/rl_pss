import logging
from telegram.ext import Updater, CallbackContext, CommandHandler
from telegram import Update
import json
import subprocess
from sys import executable


CREDEDENTIALS_PATH = "telegram_creds.json"

app_process = None
train_process = None


def start(update: Update, context: CallbackContext):
    context.bot.send_message(chat_id=update.effective_chat.id, text="I'm a bot, please talk to me!")


def run_app(update: Update, context: CallbackContext):
    global app_process
    with open('telegram_app.log', 'w') as log_file:
        app_process = subprocess.Popen([executable, "rest_agent/app.py"], stdout=log_file, stderr=log_file)
    context.bot.send_message(chat_id=update.effective_chat.id, text="Agent app.py is started!")


def stop_app(update: Update, context: CallbackContext):
    global app_process
    if isinstance(app_process, subprocess.Popen):
        app_process.kill()
        context.bot.send_message(chat_id=update.effective_chat.id, text="Agent app.py is stopped!")
    else:
        context.bot.send_message(chat_id=update.effective_chat.id, text="App has not started yet!")


def run_train(update: Update, context: CallbackContext):
    global train_process
    with open('telegram_train.log', 'w') as log_file:
        train_process = subprocess.Popen([executable, "rest_agent/train.py", "--telegram", "telegram_creds.json"], stdout=log_file, stderr=log_file)
    context.bot.send_message(chat_id=update.effective_chat.id, text="Agent train.py is started!")


def stop_train(update: Update, context: CallbackContext):
    global train_process
    if isinstance(train_process, subprocess.Popen):
        train_process.kill()
        context.bot.send_message(chat_id=update.effective_chat.id, text="Agent train.py is stopped!")
    else:
        context.bot.send_message(chat_id=update.effective_chat.id, text="Train has not started yet!")


if __name__ == '__main__':
    with open(CREDEDENTIALS_PATH, 'r') as f:
        telegram = json.load(f)
    updater = Updater(token="5572486772:AAHVwBJ4VicZ-Hz_37fE3Q_HALyEtab5YB0", use_context=True)
    dispatcher = updater.dispatcher
    logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                        level=logging.INFO)
    start_handler = CommandHandler('start', start)
    run_app_handler = CommandHandler('run_app', run_app)
    stop_app_handler = CommandHandler('stop_app', stop_app)
    run_train_handler = CommandHandler('run_train', run_train)
    stop_train_handler = CommandHandler('stop_train', stop_train)
    dispatcher.add_handler(start_handler)
    dispatcher.add_handler(run_app_handler)
    dispatcher.add_handler(stop_app_handler)
    dispatcher.add_handler(run_train_handler)
    dispatcher.add_handler(stop_train_handler)
    updater.start_polling()