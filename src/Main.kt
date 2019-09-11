import org.json.JSONObject
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.FileReader
import java.io.FileWriter
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths


fun main(args: Array<String>) {

    var awaitValue = false
    var type = ""

    var name = ""
    var nameGot = false
    val homeDirectory = System.getProperty("user.home")
    var config = "$homeDirectory/.config/gvar/var.conf"
    var configGot = false
    var value = ""
    var valueGot = false
    var remove = false
    var check = false
    var removeAll = false

    for (arg in args) {
        if (awaitValue) {
            when(type) {
                "n" -> {
                    if (!nameGot) {
                        awaitValue = false
                        name = arg
                        nameGot = true
                        type = ""
                    } else {
                        throw Exception()
                    }
                }
                "r" -> {
                    if (!nameGot) {
                        awaitValue = false
                        name = arg
                        remove = true
                        nameGot = true
                        type = ""
                    } else {
                        throw Exception()
                    }
                }
                "v" -> {
                    if (!valueGot) {
                        awaitValue = false
                        value = arg
                        valueGot = true
                        type = ""
                    } else {
                        throw Exception()
                    }
                }
                "c" -> {
                    if (!configGot) {
                        awaitValue = false
                        config = arg
                        configGot = true
                        type = ""
                    } else {
                        throw Exception()
                    }
                }
                "e" -> {
                    if (!configGot) {
                        awaitValue = false
                        check = true
                        nameGot = true
                        name = arg
                        type = ""
                    } else {
                        throw Exception()
                    }
                }
                "-n" -> throw Exception()
                "-v" -> throw Exception()
                "-c" -> throw Exception()
                "-r" -> throw Exception()
                "-e" -> throw Exception()
                else -> throw Exception()
            }
        } else {
            when(arg) {
                "-n" -> {
                    awaitValue = true
                    type = "n"
                }
                "-v" -> {
                    awaitValue = true
                    type = "v"
                }
                "-c" -> {
                    awaitValue = true
                    type = "c"
                }
                "-r" -> {
                    awaitValue = true
                    type = "r"
                }
                "-e" -> {
                    awaitValue = true
                    type = "e"
                }
                "-rA" -> {
                    type = "rA"
                    removeAll = true
                    nameGot = true
                }
                else -> throw Exception()
            }
        }
    }

    if (nameGot) {

        var path: Path = Paths.get(config)

        if (!Files.exists(path.parent)) {
            Files.createDirectory(path.parent);
        }

        if (!Files.exists(path)) {
            Files.createFile(path)
        }

        var contents = readFile(path.toString())
        if (contents.isEmpty()) contents = "{}"
        var allVars = JSONObject(contents)

        if (removeAll) {
            allVars = JSONObject("{}")
        } else {
            if (check) {
                println(allVars.has(name).toString())
            } else {
                if (allVars.has(name)) {
                    if (remove) {
                        allVars.remove(name)
                    } else {
                        if (!valueGot) {
                            println(allVars.get(name))
                        } else {
                            allVars.remove(name)
                            allVars.put(name, value)
                        }
                    }
                } else {
                    if (valueGot) {
                        allVars.put(name, value)
                    } else {
                        throw Exception()
                    }
                }
            }
        }

        contents = allVars.toString()

        writeFile(path.toString(), contents)

    } else {
        throw Exception()
    }

}

fun readFile(filename: String): String {
    var result = ""
    try {
        val br = BufferedReader(FileReader(filename))
        val sb = StringBuilder()
        var line: String? = br.readLine()
        while (line != null) {
            sb.append(line)
            line = br.readLine()
        }
        result = sb.toString()
    } catch (e: Exception) {
        e.printStackTrace()
    }

    return result
}

fun writeFile(filename: String, content: String) {
    val writer = BufferedWriter(FileWriter(filename))
    writer.write(content)

    writer.close()
}