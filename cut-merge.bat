@echo off
:: Updated script for separating and merging audio and video using ffmpeg
setlocal enabledelayedexpansion

:menu
echo ----------------------------------------
echo Choose an option:
echo 1. Separate audio and video into 2 files
echo 2. Merge video and audio into a single file
echo 3. Exit
echo ----------------------------------------
set /p option="Enter your choice (1, 2, or 3): "

if "%option%"=="1" goto separate
if "%option%"=="2" goto merge
if "%option%"=="3" goto end

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
goto end

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
goto end

:end
echo Exiting...
pause
exit
