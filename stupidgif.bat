@ECHO OFF

SET BasePath=%~dp0
SET OriginalFileName=%~1
SET OutputFileName=%OriginalFileName:~0,-4%

IF ["%OriginalFileName%"] == [""] (
ECHO ...............................................
ECHO To use this batch file, drag a 
ECHO video file onto the batch file!
ECHO ...............................................
PAUSE
GOTO :EOF
)

:SelectResolution 
CLS
ECHO ...............................................
ECHO Select GIF resolution, or 4 to EXIT
ECHO Input file: %OriginalFileName%
ECHO Output file: %OutputFileName%.gif
ECHO ...............................................
ECHO.
ECHO 1 - 240p
ECHO 2 - 480p
ECHO 3 - 720p
ECHO 4 - EXIT
ECHO.
SET /P M=: 
IF %M%==1 (
	SET Resolution=240
	GOTO SelectFramerate )
IF %M%==2 (
	SET Resolution=480
	GOTO SelectFramerate )
IF %M%==3 (
	SET Resolution=720
	GOTO SelectFramerate )
IF %M%==4 (
	GOTO :EOF )
GOTO SelectResolution

:SelectFramerate 
CLS
ECHO ...............................................
ECHO Select GIF framerate, or 4 to EXIT.
ECHO ...............................................
ECHO.
ECHO 1 - 5FPS
ECHO 2 - 15FPS
ECHO 3 - 30FPS
ECHO 4 - EXIT
ECHO.
SET /P M=: 
IF %M%==1 (
	SET Framerate=5
	GOTO FFmpeg )
IF %M%==2 (
	SET Framerate=15
	GOTO FFmpeg )
IF %M%==3 (
	SET Framerate=30
	GOTO FFmpeg )
IF %M%==4 (
	GOTO :EOF )
GOTO SelectFramerate

:FFmpeg
CLS
"%BasePath%ffmpeg.exe" -i "%~1" -filter_complex "[0:v] fps=%Framerate%,scale=-1:%Resolution%,setsar=1:1,split [a][b];[a] palettegen=stats_mode=single [p];[b][p] paletteuse=new=1" "%OutputFileName%.gif" -y
IF %ERRORLEVEL% NEQ 0 PAUSE