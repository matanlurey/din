#!/bin/bash

# Copyright (c) 2017, Matan Lurey.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

pub upgrade
dartanalyzer --fatal-warnings .
dartfmt -n --set-exit-if-changed .
pub run test
