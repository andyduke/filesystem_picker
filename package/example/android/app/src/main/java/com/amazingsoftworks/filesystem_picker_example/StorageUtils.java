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

package com.amazingsoftworks.filesystem_picker_example;

import android.content.Context;
import android.os.StatFs;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

public class StorageUtils {
    static ArrayList<HashMap<String, Object>> getExternalStorageAvailableData(Context context) {
        final File[] appsDir = context.getExternalFilesDirs(null);
        final ArrayList<HashMap<String, Object>> extRootPaths = new ArrayList<>();
        for (final File file : appsDir) {
            String path = file.getAbsolutePath();
            StatFs statFs = new StatFs(path);
            long availableBytes = statFs.getAvailableBlocksLong() * statFs.getBlockSizeLong();
            HashMap<String, Object> storageData = new HashMap<>();
            try {
                String rootPath = ""; //file.getParentFile().getParentFile().getParentFile().getParentFile().getAbsolutePath();
                storageData.put("rootPath", rootPath);
            } catch (Exception ignored) {
            }
            storageData.put("path", path);
            storageData.put("availableBytes", availableBytes);
            extRootPaths.add(storageData);
        }
        return extRootPaths;
    }

}
