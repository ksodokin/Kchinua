import os
import requests
import logging
import shutil


logging.basicConfig(level=logging.INFO)

login_url = 'https://vdsa.icrisat.org/vdsa-login.aspx'


data = {

    #IN THE LINE BELOW ENTER THE REGISTERED USERNAME AND PASSWORD
    'txtUserId': '',
    'txtPassword': '',
    'btnSubmit': 'Login'
}


sat_years = ['Data2010', 'Data2011', 'Data2012', 'Data2013', 'Data2014']
east_years = ['Ei2010','Ei2011', 'Ei2012', 'Ei2013', 'Ei2014']

# Filenames SATIndia

sat_categories = {

    'Employment':  [ "2.Employment.xlsx", "Employment_AP.xlsx", "Employment_GJ.xlsx", "Employment_KN.xlsx", "Employment_MH.xlsx", "Employment_MP.xlsx",
                      "2.Employment_AP.xlsx", "2.Employment_GJ.xlsx", "2.Employment_KN.xlsx", "2.Employment_MH.xlsx", "2.Employment_MP.xlsx" ] ,

    'GES':         [ "A.Household_details.xlsx", "B.Landholding_details.xlsx", "Gen_info.xlsx" ] ,

    'MPrice':      [ "Commodities.xlsx", "Gen_info.xlsx", "Others.xlsx", "1.M_gen_info.xlsx", "2.Commodities.xlsx", "6.Others.xlsx"  ],

    'Transaction': [ "Food_items_AP.xlsx","Food_items_GJ.xlsx","Food_items_KN.xlsx","Food_items_MH.xlsx","Food_items_MP.xlsx","Ben_govt_prog.xlsx",
                     "Non_food_items.xlsx","Non_food_items_AP.xlsx","Non_food_items_GJ.xlsx","Non_food_items_KN.xlsx","Non_food_items_MH.xlsx","Non_food_items_MP.xlsx","Food_items_TS.xlsx"]

    }

# Filenames EastIndia

east_categories = {

    'Employment':  [ "Employment.xlsx" ] ,

    'GES':         [ "Family_comp.xlsx", "Gen_info.xlsx", "Govt_dev_Prog.xlsx", "Landholding_det.xlsx", "Gov_dev_prog.xlsx"] ,

    'MPrice':      [ "Commodities.xlsx", "Gen_info.xlsx", "Others.xlsx", "1.M_gen_info.xlsx", "2.Commodities.xlsx",
                     "6.Others.xlsx", "Other.xlsx", "Commodity.xlsx", "Comodity.xlsx" ] ,

    'Transaction': [ "Exp_food_non_food_BH.xlsx", "Exp_food_non_food_JH.xlsx", "Exp_food_non_food_OR.xlsx","Exp_food_non_food.xlsx"],

    }




def login(session, login_url, data):
    """Login to the website."""
    response = session.post(login_url, data=data)
    if response.status_code == 200:
        logging.info("Logged in successfully")
        print(("Logged in successfully"))
        return True
    else:
        logging.error("Failed to log in")
        print(("Failed to log in"))
        return False


with requests.Session() as session:
    login(session, login_url, data)

    # downloading_files for SATIndia

    for year in sat_years:
        for category, files_to_download in sat_categories.items():

            category_folder = os.path.join("RawXLData", "SAT", year[4:], category)
            os.makedirs(category_folder, exist_ok=True)

            for file_name in files_to_download:
                download_url = f"https://vdsa.icrisat.org/include/microdata/SATIndia/{year}/{category}/{file_name}"
                print(f"Downloading {file_name} for {year} - {category}...")

                file_response = session.get(download_url)
                if file_response.status_code == 200:
                    # Extracting proper filename
                    proper_filename = file_name.split('.')[-2] + '.' + file_name.split('.')[-1]
                    with open(os.path.join(category_folder, proper_filename), 'wb') as f:
                        f.write(file_response.content)
                    print(f"{file_name} downloaded successfully for {year} - {category}")



    for year in east_years:
         for category, files_to_download in east_categories.items():

             category_folder = os.path.join("RawXLData", "EI", year[2:], category)
             os.makedirs(category_folder, exist_ok=True)

             for file_name in files_to_download:
                 download_url = f"https://vdsa.icrisat.org/include/microdata/EastIndia/{year}/{category}/{file_name}"
                 print(f"Downloading {file_name} for {year} - {category}...")

                 file_response = session.get(download_url)
                 if file_response.status_code == 200:
                     # Extracting proper filename
                     proper_filename = file_name.split('.')[-2] + '.' + file_name.split('.')[-1]
                     with open(os.path.join(category_folder, proper_filename), 'wb') as f:
                         f.write(file_response.content)
                     print(f"{file_name} downloaded successfully")




#SAVE FILES ON DISK

# Folder to zip
folder_to_zip = "/content/RawXLData"
zip_file_name = "/content/RawXLData.zip"

# Remove existing zip file if it exists
if os.path.exists(zip_file_name):
    os.remove(zip_file_name)

# Create the zip file
shutil.make_archive(zip_file_name.split('.zip')[0], 'zip', folder_to_zip)


# Check if the zip file is created successfully
if os.path.exists(zip_file_name):

    print("Zip file created successfully!")

    # Download the zip file
    from google.colab import files
    files.download(zip_file_name)

else:
    print("Failed to create zip file.")