:loop
	::update from github:
	echo update: %date% %time%>>server.log
	::git pull --rebase
	::або git pull
	::або git checkout
	git fetch --all
	git merge FETCH_HEAD
:runserver
	echo run server: %date% %time%>>server.log
	node server.js>>server.log
	echo stop server: %date% %time%>>server.log
	::if server failed on start, run temporary server (which can show logs or exit)....
	node debugserver.js
	if errorlevel 2 goto runserver
goto loop

:: TODO: server output=>log...