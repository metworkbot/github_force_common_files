all: ../local/bin/metwork_repos.py ../local/bin/_force.sh ../local/bin/force.sh

../local/bin/metwork_repos.py:
	wget -O $@ "https://raw.githubusercontent.com/metwork-framework/resources/master/scripts/metwork_repos.py"
	chmod +x $@

../local/bin/_force.sh: _force.sh
	cp -f $< $@
	chmod +x $@

../local/bin/force.sh: force.sh
	cp -f $< $@
	chmod +x $@
