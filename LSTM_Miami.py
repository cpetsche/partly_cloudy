#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 18 12:09:51 2021

@author: rina
"""

#import libraries
import numpy as np
from keras.models import Sequential
from keras.layers import LSTM
from keras.layers import Dense, Dropout
import pandas as pd
from matplotlib import pyplot as plt
from sklearn.preprocessing import StandardScaler, MinMaxScaler
import seaborn as sns

np.version.version
#where is file path
import os
os.getcwd()

#read csv
df = pd.read_csv('MIAMI_6_hour_flat.csv')


#filterout columns don't want
new_df = df[['LocalDateTimePeriod','Nx', 'Ny', 'pdISSRs200430']]

#filter down to the time period we want to examine
#starts at Midnight July 1st to Midnight July 5th 2020.
new_df = new_df[df.LocalDateTimePeriod <= '2020-07-05 00:00:00']
new_df = new_df[df.LocalDateTimePeriod >= '2020-07-01 00:00:00']


#DATES FOR PREDICTING:
train_dates = pd.to_datetime(new_df['LocalDateTimePeriod'])

#Variables for training:
cols = list(new_df)[1:4]

#data without date & time coolumn, converted to a float to make math easier.
df_for_training = new_df[cols].astype('float32')

#plots the last 100 points
df_for_plot = df_for_training.tail(100)
#x is just the index number though so not the most helpful plot.
df_for_plot.plot.line()

#Use sigmoid and tanh to normalize the dataset:

#This scaler actually puts it betweeen 0 and 1.
scaler = MinMaxScaler(feature_range=(0,1))
scaler = scaler.fit(df_for_training)

df_for_training_scaled = scaler.transform(df_for_training)


#Reshape input data into n_samples x timestep
trainX = []
trainY = []

#want to predict 1 day in future (07/04/20) considering 3 days of past data (07/01/20 - 07/04/20)
n_future = 1
n_past = 3

#iterate through scaled numbers and place into lists
for i in range(n_past, len(df_for_training_scaled) - n_future + 1):
    trainY.append(df_for_training_scaled[i + n_future - 1:i + n_future,0])

trainX.append(df_for_training_scaled[:len(df_for_training_scaled)-n_past, 0:df_for_training.shape[1]])

#converts list to an array
trainX, trainY = np.array(trainX), np.array(trainY)

print('trainX shape == {}.'.format(trainX.shape))
print('trainY shape == {}.'.format(trainY.shape))

# define Autoencoder model

trainX.shape[1] #13954
trainX.shape[2] #3 - number of variables
trainX.shape[0] #1 - number of days we predict


model = Sequential()
#input is number of days predicting, #variables = 3
model.add(LSTM(64, activation='relu', input_shape=(trainX.shape[0], trainX.shape[2]), return_sequences=True))
model.add(LSTM(32, activation='relu', return_sequences=False))
model.add(Dropout(0.2))
model.add(Dense(trainY.shape[1]))

model.compile(optimizer='adam', loss='mse')
model.summary()
