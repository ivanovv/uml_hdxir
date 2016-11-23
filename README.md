# uml hdxir


This small Elixir app is a port of [HandsetDetection Python api kit](https://github.com/HandsetDetection/python-apikit) and it detects device specs from UA and returns them as JSON.

To start the app:

  * Install dependencies with `mix deps.get`
  * Install Python and these libraries `tornado`, `dogpile.cache`, `PyYAML`
  * Install the device database `hd.installArchive('hd.zip')`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000/?ua=iPhone`](http://localhost:4000/?ua=iPhone) from your browser.
