defmodule Hydra.Server do
  @moduledoc """
  The Hydra server
  """

  @ascii """
                                            ..     .
                                         ..:M...  I.
           ..            ..       .  ..... . NM ..M..
         .  ........     ,        ..MZ  OMMMMMMM:.~M.
          MMMMMMMMMMMNMMMM       ... .MMMMMMMMMMMMMMM. .
        . MMMMMMMMDMMMMM+...     .. MMMMMMMMMMMMMMMMMMM .
            .. MMMMMMMMMMMMMM~.. .MMMMMMMM .. ..IMMMMMMMM.
                NMM+. MMMMMMM . .7.MMMMMMO.      .MMMMN.M...
                ....  . +MMMMMM.. .MMMMMMD.      .MMMMMMMM ...
                       ..OMMMM.:I..MMMMMMM       .=MMMMMMMMMM..
                        ..MMMMMM.. MMMMMMMM .   .~.. ...IMMMM
                         .MMMMMM  .MMMMMMMMMM.. ..M.. ....ZMM..
                         7MMMMMI:. .M.MMMMMMMMMM~ ..MMM8,.....
                        .MMMMMM...  ....MMMMMMMMMMMMMMMMMMM, ..
         ..... ...      ,MMMMMM..  ..D....MMMMMMMMMMMMMMMMIMMMMO.
           IM. +M..    .MMMMM M.  .. .?MMMMMMMMMMMM .MMMMMMMMMMMM.
          .MMZMMMMM.. ..MMMMM. .   ..MMMMMMMMMMMMMM. .MMMMMMMMMMM.
        .  MMMMMMMM?~M..MMMMN..    .MMMMMMM...MMMMMM..,...  ......
        .$MMMMMMMMMMMM .MMMMD.   ....MMMMD.   .MMMMM . .  ...N=.
       ..M.MMD. .MMMMMM.MMMMM     ..MMMMM     .MMMMM:. .. :MMMM.
       ..DMMMM. ..MMMMM.8MMMM..    ZMMMMMM..  .MMMMM ..MMMMMMMMM..
      ..MMMM ....7MMMMM .MMMMM:.  .8MMMMMMM.. :MMMMM...MMMMMMMMMMD.
       MMM .    .MMMM8M...MMMMMM....M.MMMMMMM.MMMMMM.?MMMM.. MMMMM.
     ..8M.      MMMMM Z....MMMMMMM..Z.,MMMMMMMMMMMMM..MMMM.  :MMMMM..
     . ..       MMMMM .    .?MMMMMMMM~..MMMMMMMMMMMM.MMMMMI..  ..MMM.
               .MMMMM.      ..MMMMMMMMMMMMMMMMMMMMM..=MMMMM? .   .M$.
                OMMMMN..     ...MMMMMMMMMMMMMMMMMMM...M.MMMM.      .
                .MMMMMMMM .  ...MMMMMMMMMMMMMMMMMM..  ..MMMM..
                 .MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM,... .MMMMM.
                  ..MMMMMMMMMMMMMMMMMMMMMMMMMMMM$ ,MMMMMMMM.
              ....  ..MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM .
              MMMM...MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+M:. .
        .....,ZMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM=...
    ....MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.....
  """

  def start_link(opts) do
    print_message(opts)
    Plug.Adapters.Cowboy.http(Hydra.Router, [], opts)
  end

  defp print_message(opts) do
    address = server_location(opts)
    msg = padded_string("Hydra has awoken at #{address}")

    IO.puts """

    #{@ascii}
    #{msg}
    """
  end

  defp padded_string(string) do
    len = String.length(string)
    len = div(68 - len, 2)
    padding = String.duplicate(" ", len)
    padding <> string
  end

  defp server_location(opts) do
    ip_string = opts[:ip] |> Tuple.to_list |> Enum.join(".")
    "#{ip_string}:#{opts[:port]}"
  end
end
