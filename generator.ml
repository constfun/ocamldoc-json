open Core.Std

open Odoc_info
open Odoc_info.Module
open Odoc_info.Value

let json_of_string_opt = function
  | None -> `Null
  | Some s -> `String s

let json_of_text t = `String (string_of_text t)
let json_of_text_list tl = `String (String.concat (List.map tl ~f:string_of_text))

let typed_assoc t l =
  `Assoc (("type", `String t) :: l)

let json_of_module_type mt =
  typed_assoc "module_type" [
    ("name", `String mt.mt_name);
    (* TODO: mt_info *)
    (* TODO: mt_type *)
    (* TODO: mt_kind *)
  ]

let json_of_value v =
  typed_assoc "value" [
    ("name", `String v.val_name);
  ]

let json_of_included_module im = `String "included module"
let json_of_class c = `String "class"
let json_of_class_type ct = `String "class type"
let json_of_exception e = `String "exception"
let json_of_type t = `String "type"

let json_of_module_element json_of_module = function
  | Element_module m -> json_of_module m
  | Element_module_type mt -> json_of_module_type mt
  | Element_included_module im -> json_of_included_module im
  | Element_class c -> json_of_class c
  | Element_class_type ct -> json_of_class_type ct
  | Element_value v -> json_of_value v
  | Element_exception e -> json_of_exception e
  | Element_type t -> json_of_type t
  | Element_module_comment mc -> json_of_text mc

let rec json_of_module m  =
  `Assoc [
    ("name", `String m.m_name);
    (* TODO: m_info *)
    ("elements", `List (List.map (Module.module_elements m) ~f:(json_of_module_element json_of_module)));
    ("comments", (json_of_text_list (module_comments m)));
  ]

let json_of_module_list ml =
  `Assoc [("modules", `List (List.map ml ~f:json_of_module))]

module Generator = struct
  class generator =
    object (self)
      method generate (ml : t_module list) =
        Yojson.Basic.pretty_to_channel stdout (json_of_module_list ml)
    end
end

let _ = Odoc_args.set_generator (Odoc_gen.Base (module Generator : Odoc_gen.Base))
