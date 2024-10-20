@echo off
:: Enhanced script for separating, merging, converting, compressing, and returning to the menu using ffmpeg
setlocal enabledelayedexpansion

:main
:: Loop back to the menu after each operation
cls
echo ----------------------------------------
echo Choose an option:
echo 1. Separate audio and video into 2 files
echo 2. Merge video and audio into a single file
echo 3. Convert MKV to MP4
echo 4. Compress MP4 file to reduce size
echo 5. Exit
echo ----------------------------------------
set /p option="Enter your choice (1, 2, 3, 4, or 5): "

if "%option%"=="1" goto separate
if "%option%"=="2" goto merge
if "%option%"=="3" goto convert
if "%option%"=="4" goto compress
if "%option%"=="5" goto end
goto main

:separate
set /p input="Enter the full path to the input video file: "
set /p videofile="Enter the name for the output video file (without extension): "
set /p audiofile="Enter the name for the output audio file (without extension): "

:: Separating video and audio (converting AAC audio to MP3)
ffmpeg -i "%input%" -an -vcodec copy "%videofile%.mp4" -vn -acodec mp3 "%audiofile%.mp3"

if %ERRORLEVEL%==0 (
    echo Separation complete! Video saved as "%videofile%.mp4" and audio saved as "%audiofile%.mp3"
) else (
    echo Error during processing. Please check your file paths and try again.
)
pause
goto main

:merge
set /p video="Enter the full path to the video file (without audio): "
set /p audio="Enter the full path to the audio file: "
set /p output="Enter the name for the output merged file (without extension): "

:: Merging video and audio
ffmpeg -i "%video%" -i "%audio%" -c copy "%output%.mp4"

if %ERRORLEVEL%==0 (
    echo Merging complete! The merged file is saved as "%output%.mp4"
) else (
    echo Error during processing. Please check your file paths and try again.
)
pause
goto main

:convert
set /p mkvfile="Enter the full path to the MKV file: "
set /p mp4file="Enter the name for the output MP4 file (without extension): "

:: Converting MKV to MP4
ffmpeg -i "%mkvfile%" -c copy "%mp4file%.mp4"

if %ERRORLEVEL%==0 (
    echo Conversion complete! The MKV file has been converted to "%mp4file%.mp4"
) else (
    echo Error during processing. Please check your file paths and try again.
)
pause
goto main

:compress
set /p inputfile="Enter the full path to the MP4 file: "
set /p outputfile="Enter the name for the compressed output file (without extension): "

:: Compressing MP4 (using H.264 codec with variable bitrate for size reduction)
ffmpeg -i "%inputfile%" -vcodec libx264 -crf 25 "%outputfile%.mp4"

if %ERRORLEVEL%==0 (
    echo Compression complete! The file has been saved as "%outputfile%.mp4"
) else (
    echo Error during processing. Please check your file paths and try again.
)
pause
goto main

:end
echo Exiting...
pause
exit
