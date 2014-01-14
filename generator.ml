open Core.Std

open Odoc_info
open Odoc_info.Module

module Generator = struct
  class generator =
    object (self)
      method generate (ml : t_module list) =
        let m = List.nth_exn ml 0 in
        printf "module name: %s\n" m.Module.m_name
    end
end

let _ = Odoc_args.set_generator (Odoc_gen.Base (module Generator : Odoc_gen.Base))
