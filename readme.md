# Birch theming demo

## Howto

* Run the virtual machine using `vagrant up`.

* Change colors using the `_colors` script, using it as follows:

        ./_colors red blue
        ./_colors '#3ea5ce' '#1e9ed7'

* Revert to the default theme with the `_revert` script as such:

        ./_revert

* Change images by opening the `images` symlink, and replace the `logo-open-edx.png` (desktops and tablets) and `logo-edx.png` (small devices).


## Access

* LMS is accessible at http://platform.localhost (defined in Vagrantfile).
* Studio is accessible at http://platform.localhost:18010.
