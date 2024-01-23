#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_excel_file output_csv_file"
    exit 1
fi

# Assign input and output file variables
input_excel_file="$1"
output_csv_file="$2"

# Mount path to the Windows shared folder
# Replace "WINDOWS_IP" with the IP address or hostname of your Windows machine
# Use the appropriate Windows username
mount_path="//192.168.1.101/Users/Nisha Salunke/Desktop"
mount_point="/mnt/windows_share"

# Mount the shared folder
sudo mkdir -p $mount_point

# Provide the username without a password in the mount command
sudo mount -t cifs -o username="Nisha Salunke",uid=$(id -u),gid=$(id -g),nounix,noserverino $mount_path $mount_point

# Check if the input Excel file exists
if [ ! -f "$mount_point/$(basename "$input_excel_file")" ]; then
    echo "Error: Input Excel file not found in $mount_point/$(basename "$input_excel_file")"
    ls -la $mount_point  # List files in the mounted directory for debugging purposes
    # Unmount the shared folder
    sudo umount $mount_point
    exit 1
fi

# Convert Excel to CSV using xlsx2csv
xlsx2csv "$mount_point/$(basename "$input_excel_file")" > "$output_csv_file"

# Unmount the shared folder
sudo umount $mount_point

# Check if the conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion successful. CSV file saved as $output_csv_file"
else
    echo "Error: Failed to convert Excel to CSV."
    exit 1
fi


-----------------------------------
# #!/bin/bash

# # Check if the correct number of arguments are provided
# if [ "$#" -ne 2 ]; then
#     echo "Usage: $0 input_excel_file output_csv_file"
#     exit 1
# fi

# # Assign input and output file variables
# input_excel_file="$1"
# output_csv_file="$2"

# # Mount path to the Windows shared folder
# # Replace "WINDOWS_IP" with the IP address or hostname of your Windows machine
# # Use the appropriate Windows username and password
# mount_path="//192.168.1.101/Users/Nisha Salunke/Desktop"
# mount_point="/mnt/windows_share"

# # Mount the shared folder
# sudo mkdir -p $mount_point
# sudo mount -t cifs -o username="Nisha Salunke",uid=$(id -u),gid=$(id -g) $mount_path $mount_point

# # Check if the input Excel file exists
# if [ ! -f "$mount_point/$(basename "$input_excel_file")" ]; then
#     echo "Error: Input Excel file not found in $mount_point/$(basename "$input_excel_file")"
#     ls -la $mount_point  # List files in the mounted directory for debugging purposes
#     # Unmount the shared folder
#     sudo umount $mount_point
#     exit 1
# fi

# # Convert Excel to CSV using xlsx2csv
# xlsx2csv "$mount_point/$(basename "$input_excel_file")" > "$output_csv_file"

# # Unmount the shared folder
# sudo umount $mount_point

# # Check if the conversion was successful
# if [ $? -eq 0 ]; then
#     echo "Conversion successful. CSV file saved as $output_csv_file"
# else
#     echo "Error: Failed to convert Excel to CSV."
#     exit 1
# fi
