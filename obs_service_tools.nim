import futhark
import goto
import strutils

importc:
  path "/usr/include/libxml2"
  path "./"
  rename FILE, CFile
  rename xmlChar, char
  "libxml/parser.h"
  "libxml/tree.h"
  "obs_service_tools.hpp"

const service: cstring = "_service"

proc xmlGetProp(node: ptr xmlNode, name: cstring): cstring =
    result = cast[cstring](xmlGetProp(node, cast[ptr char](name)))

proc toString(str: seq[char]): string =
    result = newStringOfCap(len(str))
    for ch in str:
        add(result, ch)

proc sh_str(value: cstring): string =
    var jret: seq[char];
    jret.add('"')
    for i in 0..<len(value):
        var g = value[i]
        case g:
            of '\\','"','`','$':
                jret.add('\\')
            else:
                discard
        jret.add(g)
    jret.add('"')
    var str = toString(jret)
    return str

proc list(service: cstring): seq[cstring] =
    var doc = xmlParseFile(service)
    var service_node = xmlDocGetRootElement(doc)
    service_node = service_node.children
    while not isNil(service_node):
        var node_name = cast[cstring](service_node.name)

        if (node_name == "service"):
            var service_name = xmlGetProp(service_node, "name")
            var service_mode = xmlGetProp(service_node, "mode")
            if isNil(service_mode) or
                service_mode == "serveronly" or
                service_mode == "trylocal" or
                service_mode == "buildtime":
                    result.add(service_name)
            else:
                discard
        service_node = service_node.next

proc list(): seq[cstring] = list(service)

proc print_list(service: cstring) =
    for m in list():
        echo m


proc print_list(): seq[cstring] = print_list(service)

type
    CommandArg = ref object
        key: cstring
        value: cstring
    CommandInit = ref object
        name: cstring
        args: seq[CommandArg]
    CommandList = ref object
        before: seq[CommandInit]
        after: seq[CommandInit]

proc `$`(commandarg: CommandArg): string =
    return join(["--",
        sh_str(commandarg.key), " ",
        sh_str(commandarg.value)], "")

proc `$`(commandinit: CommandInit): string =
    var words: seq[string]
    words.add(sh_str(commandinit.name))
    for init in commandinit.args:
        words.add($(init))
    return words.join(" ")

proc `$`(commandlist: CommandList): string =
    var words: seq[string]
    for init in commandlist.before:
        words.add($(init))
    for init in commandlist.after:
        words.add($(init))
    return words.join(" ; ")

proc get_command_arg(obj: ptr xmlNode): CommandArg =
    new(result)
    result.key = xmlGetProp(obj, "name")
    result.value = cast[cstring](xmlNodeGetContent(obj))

proc get_command_init(obj: ptr xmlNode): CommandInit =
    new(result)
    result.name = xmlGetProp(obj, "name")
    var param_node = obj.children
    while not isNil(param_node):
        if (cast[cstring](param_node.name) == "param"):
            result.args.add(get_command_arg(param_node))
        param_node = param_node.next

proc add_before(list: CommandList, obj: ptr xmlNode) =
    list.before.add(get_command_init(obj))

proc add_after(list: CommandList, obj: ptr xmlNode) =
    list.after.add(get_command_init(obj))

proc list_commands(service: cstring): CommandList =
    new(result)
    var doc = xmlParseFile(service)
    var service_node = xmlDocGetRootElement(doc)
    service_node = service_node.children
    while not isNil(service_node):
        var node_name = cast[cstring](service_node.name)
        if (node_name == "service"):
            var service_mode = xmlGetProp(service_node, "mode")
            if isNil(service_mode) or
                service_mode == "serveronly" or
                service_mode == "trylocal" or
                service_mode == "buildtime":
                    result.add_before(service_node)
            elif service_mode == "buildtime":
                    result.add_after(service_node)
            else:
                discard
        service_node = service_node.next

proc list_commands(): CommandList = list_commands(service)

echo list_commands()

