# # Automatic File Sorter in File Explorer

import os, shutil

path = r"C:/Users/chcav/Documents/PythonTutorials/"

file_name = os.listdir(path)

folder_names = ['xlsx files', 'image files', 'text files']

for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):
        #print(path + folder_names[loop])
        os.makedirs((path + folder_names[loop]))
    
for file in file_name:
    if ".xlsx" in file and not os.path.exists(path + "xlsx files/" + file):
        shutil.move(path + file, path + "xlsx files/" + file )
    elif ".png" in file and not os.path.exists(path + "image files/" + file):
        shutil.move(path + file, path + "image files/" + file )
    elif ".txt" in file and not os.path.exists(path + "text files/" + file):
        shutil.move(path + file, path + "text files/" + file )






