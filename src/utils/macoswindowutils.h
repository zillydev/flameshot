// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2017-2019 Alejandro Sirgo Rica & Contributors

#pragma once

class QWidget;

void setWindowAboveMenuBar(QWidget* widget);
void savePreviousActiveApp();
void restorePreviousActiveApp();
