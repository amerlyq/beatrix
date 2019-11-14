.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

#######
beatrix
#######

Tools to bootstrap and control complex C/C++/D projects.

.. note::
   Etymology: "beatrix" (/beɪətrɪks/) -- lat. "Beatus + Viatrix", en. "Blessed Traveller".
   Consonant: "beautiful tricks".

Still, I must begrudgingly admit, I'm deeply aware how it will unavoidably transform
into the collection of the ugly over-complicated crutches in the long while :(

Accompanied by components examples from **beatrix-templates**: https://github.com/amerlyq/beatrix-templates/



USAGE
=====

Aliases are friends of rapid development:

.. code-block:: bash

   alias m='remake'
   compdef m=remake

   # OR:
   alias m='make'
   compdef m=make



INSTALL
=======

Due to an active ongoing development, recommended way to use ``beatrix`` is based on ``git subtree`` merging with the project.

Git Subtree
-----------

Using ``git subtree`` you will merge ``beatrix`` history with the history of your project.

* Your own project will be kept standalone and not dependent on the availability of ``beatrix`` dependency online.
* You may customize directly ``beatrix`` for your own needs and still push some generic improvements to the upstream.
* BUT: to view separate history of your project only you must use different additional flags to git commands


Add remote repo as subtree to your existing project

.. code-block:: bash

   git remote add beatrix https://github.com/amerlyq/beatrix
   git subtree add --prefix=beatrix/ --branch=beatrix beatrix master
   git log --oneline --graph --decorate
   # => ref "beatrix/master"

Separate status of changes -- for your own project and dependencies

.. code-block:: bash

   git log --oneline --graph --decorate -- . ':(exclude)beatrix'
   git log --oneline --graph --decorate beatrix --

Pull remote repo for ``beatrix`` changes

.. code-block:: bash

   # git subtree --debug --list
   git fetch beatrix
   git subtree pull --prefix=beatrix/ beatrix master

Push to upstream all your latest ``beatrix`` changes -- without creating duplicate commits on the next pull

* because same commits will have different hashes in different repos
* imitates as if changes were fetched only from remote (never existed locally)

.. code-block:: bash

   git commit -m '...'
   git subtree push --prefix=beatrix/ beatrix master
   git reset --hard HEAD^
   git log -3 --graph
   git subtree pull --prefix=beatrix/ beatrix master


Git Submodule
-------------

Using ``git submodule`` you will get separate ``beatrix`` history but accompanied with numerous drawbacks:

* If remote ``beatrix`` repository will ever migrate -- your own repo will become disfunct.
* Private customizations of submodules are impossible or require too much hustle.
* If your project is submodule itself -- you will be required to support nested (recursive) submodules.

Add remote repo as submodule to your existing project

.. code-block:: bash

   git submodule add https://github.com/amerlyq/beatrix beatrix
   git submodule update --init --recursive
   git add beatrix .gitmodules
   git commit -m '[beatrix] added to project'

Pull remote repo for ``beatrix`` changes

.. code-block:: bash

   git submodule update --init --recursive
   git fetch --recurse-submodules
   git pull --recurse-submodules
   git add beatrix
   git commit -m '[beatrix] synced to upstream'

Push to upstream all your latest ``beatrix`` commits

.. code-block:: bash

   cd beatrix
   git checkout master
   git pull --rebase origin master
   git commit -m '...'
   git push
   cd ..
   git add beatrix
   git commit -m '[beatrix] pushed new changes'


Package
-------

FUTURE: install stable ``beatrix`` into your host system by native package manager.

* All files are found in the default paths of filesystem -- where primary dependencies expect them.
* BAD: sensible only when it will become stable enough to be standalone supporting tool.

Install on ArchLinux from AUR by ``aurutils``

.. code-block:: bash

   aur sync beatrix

INFO: package structure default mapping

=============  ===================================
repo mapping    system path
=============  ===================================
make            /usr/bin/beatrix
beatrix/bin     /usr/libexec/beatrix/bin/
beatrix/make    /usr/lib/beatrix/make/
beatrix/cmake   /usr/lib/beatrix/cmake/
doc             /usr/share/doc/beatrix/\*.rst
LICENSES        /usr/share/licenses/beatrix/\*.txt
=============  ===================================
