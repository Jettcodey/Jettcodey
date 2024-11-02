@echo off
:: Batch script for separating, merging, converting, compressing, and processing MKV files
setlocal enabledelayedexpansion

:main
cls
echo ----------------------------------------
echo Choose an option:
echo 1. Separate audio and video
echo 2. Merge audio and video
echo 3. Convert MKV to MP4
echo 4. Compress (reduce) MP4 file size
echo 5. Convert and compress all MKV files in a directory
echo 6. Exit
echo ----------------------------------------
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto separate_av
if "%choice%"=="2" goto merge_av
if "%choice%"=="3" goto convert_mkv_to_mp4
if "%choice%"=="4" goto compress_mp4
if "%choice%"=="5" goto process_all_mkv
if "%choice%"=="6" goto end
goto main

:separate_av
set /p input="Enter the full path to the input video file: "
set "output_video=%~dpn1_video.mp4"
set "output_audio=%~dpn1_audio.aac"

echo Separating audio and video from %input%...
ffmpeg -i "%input%" -an -c copy "%output_video%"  :: Extract video only
ffmpeg -i "%input%" -vn -c copy "%output_audio%"  :: Extract audio only

if %ERRORLEVEL%==0 (
    echo Audio saved as %output_audio%
    echo Video saved as %output_video%
) else (
    echo Error during processing. Please check your file paths.
)
pause
goto main

:merge_av
set /p video_file="Enter the full path to the video file: "
set /p audio_file="Enter the full path to the audio file: "
set "output_file=%~dpn1_merged.mp4"

echo Merging %video_file% and %audio_file% into %output_file%...
ffmpeg -i "%video_file%" -i "%audio_file%" -c copy "%output_file%"

if %ERRORLEVEL%==0 (
    echo Merged file saved as %output_file%
) else (
    echo Error during processing. Please check your file paths.
)
pause
goto main

:convert_mkv_to_mp4
set /p input_file="Enter the MKV file path: "
set "output_file=%~dpn1.mp4"

echo Converting %input_file% to MP4...
ffmpeg -i "%input_file%" -c copy "%output_file%"

if %ERRORLEVEL%==0 (
    echo Converted file saved as %output_file%
    echo Deleting original MKV file: %input_file%
    del "%input_file%"
) else (
    echo Failed to convert %input_file%.
)
pause
goto main

:compress_mp4
set /p input_file="Enter the MP4 file path: "
set "output_file=%~dpn1_compressed.mp4"

echo Compressing %input_file% with CRF...
ffmpeg -i "%input_file%" -vcodec libx264 -crf 25 "%output_file%"

if %ERRORLEVEL%==0 (
    echo Compressed file saved as %output_file%
    echo Deleting uncompressed MP4 file: %input_file%
    del "%input_file%"
) else (
    echo Failed to compress %input_file%.
)
pause
goto main

:process_all_mkv
set /p dir="Enter the directory path containing MKV files: "
echo Processing all MKV files in %dir%...

for %%f in ("%dir%\*.mkv") do (
    if exist "%%f" (
        echo Processing %%f...
        set "output_file=%%~dpnf.mp4"
        ffmpeg -i "%%f" -c copy "!output_file!"
        
        if %ERRORLEVEL%==0 (
            echo Converted file saved as !output_file!
            del "%%f"
            echo Compressing !output_file!
            set "compressed_file=%%~dpnf_compressed.mp4"
            ffmpeg -i "!output_file!" -vcodec libx264 -crf 25 "!compressed_file!"
            
            if %ERRORLEVEL%==0 (
                echo Compressed file saved as !compressed_file!
                del "!output_file!"
            ) else (
                echo Failed to compress !output_file!.
            )
        ) else (
            echo Failed to convert %%f to MP4.
        )
    ) else (
        echo No MKV files found in %dir%.
        pause
        goto main
    )
)
pause
goto main

:end
echo Exiting...
pause
exit
