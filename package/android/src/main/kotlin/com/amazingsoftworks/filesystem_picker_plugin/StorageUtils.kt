/*
 * SOURCE/ORIGINAL: https://github.com/AmudAnan/flutter_path_provider_ex/blob/master/android/src/main/java/com/amudanan/path_provider_ex/StorageUtils.java
 *
 * Copyright 2019 Yoav Rofé, Amud Anan
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * */
package com.amazingsoftworks.filesystem_picker_plugin

import android.content.Context
import android.os.StatFs
import java.util.*

object StorageUtils {
    fun getExternalStorageAvailableData(context: Context): ArrayList<HashMap<String, Any>> {
        val appsDir = context.getExternalFilesDirs(null)
        val extRootPaths = ArrayList<HashMap<String, Any>>()
        for (file in appsDir) {
            val path = file.absolutePath
            val statFs = StatFs(path)
            val availableBytes = statFs.availableBlocksLong * statFs.blockSizeLong
            val storageData = HashMap<String, Any>()
            try {
                val rootPath = ""
                storageData["rootPath"] = rootPath
            } catch (ignored: Exception) {
            }
            storageData["path"] = path
            storageData["availableBytes"] = availableBytes
            extRootPaths.add(storageData)
        }
        return extRootPaths
    }
}