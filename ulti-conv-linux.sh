#!/bin/bash

# Function to separate audio and video
separate_av() {
    input_file="$1"
    output_audio="${input_file%.*}_audio.aac"
    output_video="${input_file%.*}_video.mp4"
    
    echo "Separating audio and video from $input_file..."
    ffmpeg -i "$input_file" -an -c copy "$output_video"  # Extract video (without audio)
    ffmpeg -i "$input_file" -vn -c copy "$output_audio"  # Extract audio (without video)
    
    echo "Audio saved as $output_audio"
    echo "Video saved as $output_video"
}

# Function to merge audio and video
merge_av() {
    video_file="$1"
    audio_file="$2"
    output_file="${video_file%.*}_merged.mp4"
    
    echo "Merging $video_file and $audio_file into $output_file..."
    ffmpeg -i "$video_file" -i "$audio_file" -c copy "$output_file"
    
    echo "Merged file saved as $output_file"
}

# Function to convert MKV to MP4
convert_mkv_to_mp4() {
    input_file="$1"
    output_file="${input_file%.*}.mp4"
    
    echo "Converting $input_file to MP4..."
    ffmpeg -i "$input_file" -c copy "$output_file"
    
    if [ $? -eq 0 ]; then
        echo "Converted file saved as $output_file"
        echo "Deleting original MKV file: $input_file"
        rm "$input_file"
    else
        echo "Failed to convert $input_file to MP4."
    fi
}

# Function to compress/reduce MP4 file size
compress_mp4() {
    input_file="$1"
    output_file="${input_file%.*}_compressed.mp4"
	
	echo "Compressing $input_file with CRF..."
    ffmpeg -i "$input_file" -vcodec libx264 -crf 25 "$output_file"
    
    if [ $? -eq 0 ]; then
        echo "Compressed file saved as $output_file"
        echo "Deleting uncompressed MP4 file: $input_file"
        rm "$input_file"
    else
        echo "Failed to compress $input_file."
    fi
}

# Function to process all MKV files in a directory
process_all_mkv() {
    dir="$1"
    echo "Processing all MKV files in $dir..."
    
    for file in "$dir"/*.mkv; do
        if [ -f "$file" ]; then
            echo "Processing $file..."
            convert_mkv_to_mp4 "$file"
            mp4_file="${file%.*}.mp4"
            compress_mp4 "$mp4_file"
        else
            echo "No MKV files found in $dir."
            break
        fi
    done
}

# Function to display menu and handle choices
show_menu() {
    echo
    echo "Choose an option:"
    echo "1. Separate audio and video"
    echo "2. Merge audio and video"
    echo "3. Convert MKV to MP4"
    echo "4. Compress (reduce) MP4 file size"
    echo "5. Convert and compress all MKV files in a directory"
    echo "6. Exit"
    read -p "Enter your choice (1-6): " choice
    echo
    
    case $choice in
        1)
            read -p "Enter the input file path: " input_file
            separate_av "$input_file"
            ;;
        2)
            read -p "Enter the video file path: " video_file
            read -p "Enter the audio file path: " audio_file
            merge_av "$video_file" "$audio_file"
            ;;
        3)
            read -p "Enter the MKV file path: " input_file
            convert_mkv_to_mp4 "$input_file"
            ;;
        4)
            read -p "Enter the MP4 file path: " input_file
            compress_mp4 "$input_file"
            ;;
        5)
            read -p "Enter the directory path: " dir
            process_all_mkv "$dir"
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Main loop to keep showing the menu
while true; do
    show_menu
done
