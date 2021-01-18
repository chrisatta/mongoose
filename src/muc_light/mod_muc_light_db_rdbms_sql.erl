%%%----------------------------------------------------------------------
%%% File    : mod_muc_light_db_rdbms_sql.erl
%%% Author  : Piotr Nosek <piotr.nosek@erlang-solutions.com>
%%% Purpose : RDBMS backend queries for mod_muc_light
%%% Created : 29 Nov 2016 by Piotr Nosek <piotr.nosek@erlang-solutions.com>
%%%
%%% This program is free software; you can redistribute it and/or
%%% modify it under the terms of the GNU General Public License as
%%% published by the Free Software Foundation; either version 2 of the
%%% License, or (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%%% General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with this program; if not, write to the Free Software
%%% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
%%%
%%%----------------------------------------------------------------------

-module(mod_muc_light_db_rdbms_sql).
-author('piotr.nosek@erlang-solutions.com').

-include("mod_muc_light.hrl").

-export([select_blocking/2, select_blocking_cnt/3, insert_blocking/4,
         delete_blocking/4, delete_blocking/2]).

-define(ESC(T), mongoose_rdbms:use_escaped_string(mongoose_rdbms:escape_string(T))).

%%====================================================================
%% Blocking
%%====================================================================

-spec select_blocking(LUser :: jid:luser(), LServer :: jid:lserver()) -> iolist().
select_blocking(LUser, LServer) ->
    ["SELECT what, who FROM muc_light_blocking WHERE luser = ", ?ESC(LUser),
                                               " AND lserver = ", ?ESC(LServer)].

-spec select_blocking_cnt(LUser :: jid:luser(), LServer :: jid:lserver(),
                           WhatWhos :: [{blocking_who(), jid:simple_bare_jid()}]) -> iolist().
select_blocking_cnt(LUser, LServer, WhatWhos) ->
    [ _ | WhatWhosWhere ] = lists:flatmap(
                              fun({What, Who}) ->
                                      [" OR ", "(what = ", mod_muc_light_db_rdbms:what_atom2db(What),
                                           " AND who = ", ?ESC(jid:to_binary(Who)), ")"] end,
                              WhatWhos),
    ["SELECT COUNT(*) FROM muc_light_blocking WHERE luser = ", ?ESC(LUser),
                                              " AND lserver = ", ?ESC(LServer),
                                              " AND (", WhatWhosWhere, ")"].

-spec insert_blocking(LUser :: jid:luser(), LServer :: jid:lserver(),
                       What :: blocking_what(), Who :: blocking_who()) -> iolist().
insert_blocking(LUser, LServer, What, Who) ->
    ["INSERT INTO muc_light_blocking (luser, lserver, what, who)"
     " VALUES (", ?ESC(LUser), ", ", ?ESC(LServer), ", ",
               mod_muc_light_db_rdbms:what_atom2db(What), ", ", ?ESC(jid:to_binary(Who)), ")"].

-spec delete_blocking(LUser :: jid:luser(), LServer :: jid:lserver(),
                         What :: blocking_what(), Who :: blocking_who()) -> iolist().
delete_blocking(LUser, LServer, What, Who) ->
    ["DELETE FROM muc_light_blocking WHERE luser = ", ?ESC(LUser),
                                     " AND lserver = ", ?ESC(LServer),
                                     " AND what = ", mod_muc_light_db_rdbms:what_atom2db(What),
                                     " AND who = ", ?ESC(jid:to_binary(Who))].

-spec delete_blocking(UserU :: jid:luser(), UserS :: jid:lserver()) -> iolist().
delete_blocking(UserU, UserS) ->
    ["DELETE FROM muc_light_blocking"
     " WHERE luser = ", ?ESC(UserU), " AND lserver = ", ?ESC(UserS)].
