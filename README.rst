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


INSTALL
=======

Due to an active ongoing development, recommended way to use ``beatrix`` is based on ``git subtree`` merging with the project.

* Your own project will be kept standalone and not dependent on the availability of ``beatrix`` dependency online.
* You may customize directly ``beatrix`` for your own needs and still push some generic improvements to the upstream.


Git Subtree
-----------

Add remote repo as subtree to your existing project

.. code-block:: bash

   git remote add beatrix https://github/amerlyq/beatrix
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
