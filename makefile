.PHONY: test setup _wordpress/wordpress/wp-content/plugins/mammoth-docx-converter mammoth-docx-converter/mammoth-editor.js

setup: mammoth-docx-converter/mammoth-editor.js mammoth-docx-converter/readme.txt _wordpress/wordpress/wp-content/plugins/mammoth-docx-converter

mammoth-docx-converter/mammoth-editor.js:
	cd js; npm install
	js/node_modules/.bin/browserify js/mammoth-editor.js > $@

mammoth-docx-converter/readme.txt: readme.txt
	cp readme.txt $@

_wordpress:
	python3 install-wordpress.py

_wordpress/wordpress/wp-content/plugins/mammoth-docx-converter: _wordpress
	rm -f $@
	ln -sfT `pwd`/mammoth-docx-converter $@

tests/_virtualenv/bin/python:
	virtualenv tests/_virtualenv
	
test: setup tests/_virtualenv/bin/python
	tests/_virtualenv/bin/pip install -r tests/requirements.txt
	
	_wordpress/bin/wp plugin deactivate --all
	_wordpress/bin/wp plugin activate mammoth-docx-converter
	tests/_virtualenv/bin/nosetests tests
	
	_wordpress/bin/wp plugin deactivate --all
	_wordpress/bin/wp plugin install ckeditor-for-wordpress
	_wordpress/bin/wp plugin activate ckeditor-for-wordpress
	_wordpress/bin/wp plugin activate mammoth-docx-converter
	tests/_virtualenv/bin/nosetests tests
