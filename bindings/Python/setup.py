#!/usr/bin/python
#
# Copyright (c) 2004-2005, Nick Piper.
# 
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
# your option) any later version.
# 
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library
# General Public License for more details.
# 
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
# 
# $Id: setup.py.in,v 1.7 2006/05/31 17:59:55 desrod Exp $

from distutils.core import setup, Extension

setup(name = "python-libpisock",
      version = "0.12.6",
      description = "Python bindings for the pisock library.",
      author = "Nick Piper",
      author_email = "nick@nickpiper.co.uk",
      url = "http://www.pilot-link.org/",

      ext_modules = [Extension("_pisock",["src/pisock_wrap.c"],
                               include_dirs=['../../include'],
                               library_dirs=['../../libpisock/.libs'],
                               libraries=['pisock'],
                               )
                     ],
      package_dir = {'': 'src'},
      py_modules = ["pisock","pisockextras"])

