--[[


             SEGRETO         
                             
          By @PrswShrr       
                             
       Channel > @Segreto_Ch 

	 
]]
--Check members #Add supergroup
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "Promote me to admin first!")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = 'no',
		  lock_link = "no",
          flood = 'yes',
		  lock_spam = 'yes',
		  lock_sticker = 'no',
		  member = 'no',
      lock_fwd = 'no',
      lock_tag = 'no',
	  lock_emoji = 'no',
      lock_badword = 'no',
      lock_hashtag = 'no',
      lock_reply = 'no',
		  public = 'no',
		  lock_rtl = 'no',
		  lock_tgservice = 'no',
		  lock_contacts = 'no',
		  strict = 'no'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
	  local text = "<b>Group name</b> : <code>"..msg.to.title.."</code>\n<b>Group has been Added by</b> : @"..msg.from.username.." !"
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
	  local text = "<b>Group name</b> : <code>"..msg.to.title.."</code>\n<b>Group has been Removed by</b> : @"..msg.from.username.." !"
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("?", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end


local function check_member_super_deleted(cb_extra, success, result)
local receiver = cb_extra.receiver
 local msg = cb_extra.msg
  local deleted = 0 
if success == 0 then
send_large_msg(receiver, "first set me as admin!") 
end
for k,v in pairs(result) do
  if not v.first_name and not v.last_name then
deleted = deleted + 1
 kick_user(v.peer_id,msg.to.id)
 end
 end
 send_large_msg(receiver, "<b>Successfully Kicked all!</b>\n<b>Number of Deleted Accounts kicked</b>:"..deleted) 
 end 


local function callback_clean_bots (extra, success, result)
	local msg = extra.msg
	local receiver = 'channel#id'..msg.to.id
	local channel_id = msg.to.id
	for k,v in pairs(result) do
		local bot_id = v.peer_id
		kick_user(bot_id,channel_id)
	end
end
local function callback_clean_members (extra, success, result)
  local msg = extra.msg
  local receiver = 'channel#id'..msg.to.id
  local channel_id = msg.to.id
  for k,v in pairs(result) do
  local users_id = v.peer_id
  kick_user(users_id,channel_id)
  end
end


--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="<b>Group name</b> : ["..result.title.."]\n\n"
local admin_num = "<b>Admins</b>: "..result.admins_count.."\n"
local user_num = "<b>Users</b>: "..result.participants_count.."\n"
local kicked_num = "<b>Kicked users </b>: "..result.kicked_count.."\n"
local channel_id = "<b>ID: "..result.peer_id.."\n"
local user_name = "<b>Your Username</b> : "..msg.from.username.."\n"
if result.username then
	channel_username = "Username: @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_name..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "Members for "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("?", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "Kicked Members for SuperGroup "..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("?", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
	end
------------------------FunctionBanHammer

------------------------FunctionAddAdmin&Support
local function username_id(cb_extra, success, result)
   local mod_cmd = cb_extra.mod_cmd
   local receiver = cb_extra.receiver
   local member = cb_extra.member
   local text = 'No user @'..member..' in this group.'
   for k,v in pairs(result.members) do
      vusername = v.username
      if vusername == member then
        member_username = member
        member_id = v.peer_id
        if mod_cmd == 'addadmin' then
            return admin_user_promote(receiver, member_username, member_id)
        elseif mod_cmd == 'removeadmin' then
            return admin_user_demote(receiver, member_username, member_id)
        end
      end
   end
   send_large_msg(receiver, text)
end

local function username_id2(cb_extra, success, result)
   local mod_cmd = cb_extra.mod_cmd
   local receiver = cb_extra.receiver
   local member = cb_extra.member
   local text = 'No user @'..member..' in this group.'
   for k,v in pairs(result) do
      vusername = v.username
      if vusername == member then
        member_username = member
        member_id = v.peer_id
        if mod_cmd == 'addadmin' then
            return admin_user_promote(receiver, member_username, member_id)
        elseif mod_cmd == 'removeadmin' then
            return admin_user_demote(receiver, member_username, member_id)
        end
      end
   end
   send_large_msg(receiver, text)
end

local function res_user_support(cb_extra, success, result)
   local receiver = cb_extra.receiver
   local get_cmd = cb_extra.get_cmd
   local support_id = result.peer_id
	if get_cmd == 'addsupport' then
		support_add(support_id)
		send_large_msg(receiver, "User ["..support_id.."] has been added to the support team")
	elseif get_cmd == 'removesupport' then
		support_remove(support_id)
		send_large_msg(receiver, "User ["..support_id.."] has been removed from the support team")
	end
end

local function admin_user_promote(receiver, member_username, member_id)
        local data = load_data(_config.moderation.data)
        if not data['admins'] then
                data['admins'] = {}
            save_data(_config.moderation.data, data)
        end
        if data['admins'][tostring(member_id)] then
            return send_large_msg(receiver, '@'..member_username..' is already an admin.')
        end
        data['admins'][tostring(member_id)] = member_username
        save_data(_config.moderation.data, data)
	return send_large_msg(receiver, '@'..member_username..' has been promoted as admin.')
end

local function admin_user_demote(receiver, member_username, member_id)
    local data = load_data(_config.moderation.data)
    if not data['admins'] then
		data['admins'] = {}
        save_data(_config.moderation.data, data)
	end
	if not data['admins'][tostring(member_id)] then
		send_large_msg(receiver, "@"..member_username..' is not an admin.')
		return
    end
	data['admins'][tostring(member_id)] = nil
	save_data(_config.moderation.data, data)
	send_large_msg(receiver, 'Admin @'..member_username..' has been demoted.')
end
------------------------FunctionAdminList
local function admin_list(msg)
    local data = load_data(_config.moderation.data)
	local admins = 'admins'
	if not data[tostring(admins)] then
		data[tostring(admins)] = {}
		save_data(_config.moderation.data, data)
	end
	local message = '<b>List of global admins:</b>:\n'
	for k,v in pairs(data[tostring(admins)]) do
		message = message .. '-- @' .. v .. ' [' .. k .. '] ' ..'\n'
	end
	return message
end

------------------------FunctionReload
local function reload_plugins( )
	plugins = {}
  return load_plugins()
end

------------------------InviteFunection
local function add_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    if msg.to.type == 'chat' then
        chat_add_user('chat#id'..chat, 'user#id'..user, ok_cb, false)
    elseif msg.to.type == 'channel' then
        channel_invite('channel#id'..chat, 'user#id'..user, ok_cb, false)
    end
end

local function add_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_username = result.username
    print(chat_id)
    if chat_type == 'chat' then
        chat_add_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    elseif chat_type == 'channel' then
        channel_invite('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    end
end

------------------------RmsgFunction
--[[local function history(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, '[ '..#result..' ] Messages Of Supergroup Removed', ok_cb, false)
  else
    send_msg(extra.chatid, 'Messages Removed', ok_cb, false)
  end
end]]--bug

--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    return 'Link posting <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Link Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    return '<b>Mute Link was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Link Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'yes' then
    return reply_msg(msg.id,"Commands <i>is already Locked</i>\n<b>(Please do not try again)</b>!", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_cmd'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'cmd:'..msg.to.id		
    redis:set(hash, true)		
    return '<b>Use Bot Commands Status switched to</b> : <code>Lock</code>\n<b>Now Members cant use normal commands !</b>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'no' then
    return reply_msg(msg.id,"Commands is not Mute!", ok_cb, false)
  else
    data[tostring(target)]['settings']['lock_cmd'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'cmd:'..msg.to.id
    redis:del(hash)		
    return '<b>Use Bot Commands Status switched to</b> : <code>UnLock</code>\n<b>Now Members can use normal commands !</b>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return ""
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
    return 'SuperGroup spam <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Spam Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
    return '<b>Mute Spam[long msg] was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Spam Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end


local function lock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return ""
  end
  local group_emoji_lock = data[tostring(target)]['settings']['lock_emoji']
  if group_emoji_lock == 'yes' then
    return 'SuperGroup Emoji <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_emoji'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Emoji Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['lock_emoji']
  if group_emoji_lock == 'no' then
    return '<b>Emoji Status was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_emoji'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Emoji Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end


local function lock_group_badword(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return ""
  end
  local group_badword_lock = data[tostring(target)]['settings']['lock_badword']
  if group_badword_lock == 'yes' then
    return 'SuperGroup badword <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_badword'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>badword Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_badword(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_badword_lock = data[tostring(target)]['settings']['lock_badword']
  if group_badword_lock == 'no' then
    return '<b>badword Status was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_badword'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>badword Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    return 'Flood <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Flood Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return '<b>Mute flood was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Flood Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    return 'Arabic <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Arabic Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    return '<b>Mute Arabic was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Arabic Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'yes' then
    return 'tag <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Tag[ @ ] Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'no' then
    return '<b>Mute Tag[ @ ] was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Tag Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_hashtag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_hashtag_lock = data[tostring(target)]['settings']['lock_hashtag']
  if group_hashtag_lock == 'yes' then
    return 'hashtag <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_hashtag'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Hashtag[ # ] Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_hashtag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_hashtag_lock = data[tostring(target)]['settings']['lock_hashtag']
  if group_hashtag_lock == 'no' then
    return '<b>Mute HashTag[ # ] was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_hashtag'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Hashtag Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end


local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == 'yes' then
    return 'forward <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_fwd'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Forward Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == 'no' then
    return '<b>Mute Forward was on</b> : <code>unlock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_fwd'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Forward Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    return 'SuperGroup members are already Mute'
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
    return '<b>Member Join Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    return '<b>Mute Member join was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Join member Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
    return 'RTL <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>RTL[Right to left PM] Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
    return '<b>Mute RTL[Right To left Mesages] was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>RTL Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'yes' then
    return 'Tgservice <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>TGService[Join Group Pm] Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'no' then
    return '<b>Mute TGservice[Join Group Pm] was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>TGService Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
    return 'Sticker posting <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Sticker Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'no' then
    return '<b>Mute Sticker was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Sticker Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end


local function lock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['lock_reply']
  if group_reply_lock == 'yes' then
    return 'reply <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_reply'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Reply Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['lock_reply']
  if group_reply_lock == 'no' then
    return '<b>Mute Reply was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_reply'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Share Contact Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'yes' then
    return 'Contact posting <i>is already Locked</i>\n<b>(Please do not try again)</b>'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Share Contact Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'no' then
    return '<b>Mute Contacts was on</b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Contacts Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'yes' then
    return 'Settings are already strictly enforced'
  else
    data[tostring(target)]['settings']['strict'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Stricting Settings Status switched to</b> : <code>Lock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'no' then
    return '<b>Stricting Settings was on </b> : <code>UnLock</code>\n<b>Status not changed !</b>'
  else
    data[tostring(target)]['settings']['strict'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Stricting Settings Status switched to</b> : <code>UnLock</code>\n<b>Changed by : </b>@'..(msg.from.username or msg.from.first_name)
  end
end
------------------------End supergroup locks
------------------------MsgChecks
------------------------'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'SuperGroup rules set'
end

------------------------'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'No rules available.'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..' rules:\n\n'..rules:gsub("/n", " ")
  return rules
end

------------------------Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return "For moderators only!"
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'yes' then
    return 'Group is already public'
  else
    data[tostring(target)]['settings']['public'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return 'SuperGroup is now: public'
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'no' then
    return 'Group is not public'
  else
    data[tostring(target)]['settings']['public'] = 'no'
	data[tostring(target)]['long_id'] = msg.to.long_id
    save_data(_config.moderation.data, data)
    return 'SuperGroup is now: not public'
  end
end

------------------------Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 5
      	end
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
        if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_fwd'] then
			data[tostring(target)]['settings']['lock_fwd'] = 'no'
		end
	end
        if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tag'] then
			data[tostring(target)]['settings']['lock_tag'] = 'no'
		end
	end
        if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_hashtag'] then
			data[tostring(target)]['settings']['lock_hashtag'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
        end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
		end
	end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_contacts'] then
			data[tostring(target)]['settings']['lock_contacts'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_badword'] then
			data[tostring(target)]['settings']['lock_badword'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_emoji'] then
			data[tostring(target)]['settings']['lock_emoji'] = 'no'
		end
	end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_reply'] then
			data[tostring(target)]['settings']['lock_reply'] = 'no'
		end
	end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_cmd'] then
			data[tostring(target)]['settings']['lock_cmd'] = 'no'
		end
	end	
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
  local settings = data[tostring(target)]['settings']
  local text = "<b>Group Settings</b> :\n"
.."<b>Reply</b> > "..settings.lock_reply.."\n"
.."<b>Contact share</b> > "..settings.lock_contacts.."\n"
.."<b>Links</b> > "..settings.lock_link.."\n"
.."<b>Forward</b> > "..settings.lock_fwd.."\n"
.."<b>Hashtag(#)</b> > "..settings.lock_hashtag.."\n"
.."<b>Tag(@)</b> > "..settings.lock_tag.."\n"
.."<b>Sticker</b> > "..settings.lock_sticker.."\n"
.."<b>Flood</b> > "..settings.flood.."\n"
.."<b>Spam</b> > "..settings.lock_spam.."\n"
.."<b>Cmds</b> > "..settings.lock_cmd.."\n"
.."<b>Badwords</b> > "..settings.lock_badword.."\n"
.."<b>Emoji</b> > "..settings.lock_emoji.."\n"
.."<b>Arabic</b> > "..settings.lock_arabic.."\n"
.."<b>Member</b> > "..settings.lock_member.."\n"
.."<b>RTL</b> > "..settings.lock_rtl.."\n"
.."<b>Service</b> > "..settings.lock_tgservice.."\n"
.."<b>Flood number</b> > "..NUM_MSG_MAX.."\n"
.."<b>Strict settings</b> > "..settings.strict.."\n<b>__________</b>\n"
.."<b>Channel</b> > @Segreto_Ch\n"
.."<b>Requester Information</b> :\n"
.."<code>?Name</code> > <b>"..msg.from.first_name.."</b> <b>"..(msg.from.last_name or '').."</b>\n"
.."<code>?Your Username</code> > @"..(msg.from.username or '')
   if string.match(text, "yes") then text = string.gsub(text, "yes", "<code>Lock</code>") end
   if string.match(text, "no") then text = string.gsub(text, "no", "<code>Unlock</code>") end 
return reply_msg(msg.id,text,ok_cb,false)
  end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '@')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' is already a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' is not a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '@')
  if not data[group] then
    return send_large_msg(receiver, 'SuperGroup is not added.')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' is already a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' has been promoted.')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group is not added.')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' is not a moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' has been demoted.')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return 'SuperGroup is not added.'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return 'No moderator in this group.'
  end
  local i = 1
  local message = '\n<b>List of moderators for</b> <code>' .. string.gsub(msg.to.print_name, '_', ' ') .. '</code>:\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

------------------------Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("?", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for: ["..result.from.peer_id.."]")
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id by service msg for: ["..user_id.."]")
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for msg fwd from: ["..result.fwd_from.peer_id.."]")
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		----savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply to sev. msg.")
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted a message by reply")
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." set as an admin"
		else
			text = "[ "..user_id.." ]set as an admin"
		end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..user_id.."] as admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "You can't demote global admins!")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." has been demoted from admin"
		else
			text = "[ "..user_id.." ] has been demoted from admin"
		end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted: ["..user_id.."] from admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..result.from.peer_id.."] as owner by reply")
			if result.from.username then
				text = "@"..result.from.username.." <code>[ "..result.from.peer_id.." ]</code> added as owner"
			else
				text = "<code>[ "..result.from.peer_id.." ]</code> added as owner"
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("?", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("?", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted mod: @"..member_username.."["..user_id.."] by reply")
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] removed from the muted user list")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] added to the muted user list")
		end
	end
end
------------------------End by reply actions

------------------------By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "You can't demote global admins!")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been demoted from admin"
			send_large_msg(receiver, text)
		else
			text = "[ "..result.peer_id.." ] has been demoted from admin"
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

------------------------Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	--[[elseif get_cmd == "channel_block" then
		local user_id = result.peer_id
		local channel_id = extra.channelid
    local sender = extra.sender
    if member_id == sender then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
		if is_momod2(member_id, channel_id) and not is_admin2(sender) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		channel_set_admin(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been set as an admin"
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "setowner" then
		local receiver = extra.channel
		local channel = string.gsub(receiver, 'channel#id', '')
		local from_id = extra.from_id
		local group_owner = data[tostring(channel)]['set_owner']
		if group_owner then
			local user = "user#id"..group_owner
			if not is_admin2(group_owner) and not is_support(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
			--savelog(channel, name_log.." ["..from_id.."] set ["..result.peer_id.."] as owner by username")
		if result.username then
			text = member_username.." <code>[ "..result.peer_id.." ]</code> added as owner"
		else
			text = "<code>[ "..result.peer_id.." ]</code> added as owner"
		end
		send_large_msg(receiver, text)
  end]]
	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "You can't demote global admins!")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been demoted from admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been demoted from admin"
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] removed from muted user list")
		elseif is_owner(extra.msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] added to muted user list")
		end
	end
end
------------------------End resolve username actions

------------------------Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("?", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = 'No user @'..member..' in this SuperGroup.'
  else
    text = 'No user ['..memberid..'] in this SuperGroup.'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
      end
      if v.username then
        text = ""
        --savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..v.username.." ["..v.peer_id.."]")
      else
        text = ""
        --savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..v.peer_id.."]")
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "setadmin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "@"..v.username.." ["..v.peer_id.."] has been set as an admin"
        --savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..v.username.." ["..v.peer_id.."]")
      else
        text = "["..v.peer_id.."] has been set as an admin"
        --savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin "..v.peer_id)
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
 elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
					--savelog(channel, name_log.."["..from_id.."] set ["..v.peer_id.."] as owner by username")
				if result.username then
					text = member_username.." <code>["..v.peer_id.."]</code> added as owner"
				else
					text = "<code>["..v.peer_id.."]</code> added as owner"
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
                                end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				--savelog(channel, name_log.."["..from_id.."] set ["..memberid.."] as owner by username")
				text = "<code>["..memberid.."]</code> added as owner"
			end
		end
	end
send_large_msg(receiver, text)
end
------------------------End non-channel_invite username actions

------------------------'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'Photo saved!', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

------------------------Run function
local function run(msg, matches)

local bot_id = 188287037
local rlm = 1074227531

if matches[1]:lower() == 'join' and matches[2] and is_admin(msg) then
        channel_invite('channel#id'..matches[2], 'user#id'..msg.from.id, ok_cb, false)
      end
if matches[1]:lower() == 'leave' and matches[2] and is_sudo(msg) then
                          leave_channel('channel#id'..matches[2], ok_cb, false)
                          apileavechat(msg, '-100'..matches[2])
                     return '<b>Done</b>\n\n<i>I Exited the Group</i>: '..matches[2]
                  elseif matches[1]:lower() == 'leave' and not matches[2] and is_sudo(msg) then
                    leave_channel('channel#id'..msg.to.id, ok_cb, false)
                    apileavechat(msg, '-100'..msg.to.id)
                  end 
				  
if matches[1]:lower() == 'setexpire' then
    if not is_sudo(msg) then return end
    local time = os.time()
    local buytime = tonumber(os.time())
    local timeexpire = tonumber(buytime) + (tonumber(matches[2]) * 86400)
    redis:hset('expiretime',get_receiver(msg),timeexpire)
    return '<b>Group charged for</b><code> "..matches[2].." </code><b>Days</b>'
  end
  if matches[1]:lower() == 'expire' then
    local expiretime = redis:hget ('expiretime', get_receiver(msg))
    if not expiretime then return 'Unlimited' else
      local now = tonumber(os.time())
      return (math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1) .. " <b>Days</b>"
    end
  end

  if matches[1]:lower() == '1m' and matches[2] then
    if not is_sudo(msg) then return end
    local time = os.time()
    local buytime = tonumber(os.time())
    local timeexpire = tonumber(buytime) + (tonumber(1 * 30) * 86400)
    redis:hset('expiretime','channel#id'..matches[2],timeexpire)
    send_large_msg('channel#id'..matches[2], 'Group charged For 30 Days', ok_cb, false)
    return reply_msg(msg.id, 'Done', ok_cb, false)
  end

  if matches[1]:lower() == '3m' and matches[2] then
    if not is_sudo(msg) then return end
    local time = os.time()
    local buytime = tonumber(os.time())
    local timeexpire = tonumber(buytime) + (tonumber(3 * 30) * 86400)
    redis:hset('expiretime','channel#id'..matches[2],timeexpire)
    send_large_msg('channel#id'..matches[2], 'Group charged For 90 Days', ok_cb, false)
    return reply_msg(msg.id, 'Done', ok_cb, false)
  end
  if matches[1]:lower() == 'unlimite' and matches[2] then
    if not is_sudo(msg) then return end
    local time = os.time()
    local buytime = tonumber(os.time())
    local timeexpire = tonumber(buytime) + (tonumber(2 * 99999999999) * 86400)
    redis:hset('expiretime','channel#id'..matches[2],timeexpire)
    send_large_msg('channel#id'..matches[2], 'Group charged For unlimited', ok_cb, false)
    return reply_msg(msg.id, 'Done', ok_cb, false)
  end


	if msg.to.type == 'chat' then
		if matches[1]:lower() == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			return "<b>Darket Nmikonam :| </b>"
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("?", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
	local creed = "channel#id"..1074227531
    local text_rem = '<b>New Group Removed !!!!</b> :\n<b>Gp Info</b> :\n<b>Gp ID </b>: <code>'..msg.to.id..'</code>\n<b>Gp name</b> : <b>'..msg.to.title..'</b>\n<b>Remover Info</b>\n<b>User ID</b> : <code>'..msg.from.id..'</code>\n<b>Username </b>: '..(msg.from.username or '')..'\n<b>You can leave the bot by</b> /leave'..msg.to.id..' <b>Command</b>\n<b>You can join it by</b> : /join'..msg.to.id..' <b>command</b>\n<b>To charge it for 1/2/3/unlimite use</b> :\n /1m'..msg.to.id..'\n/2m'..msg.to.id..'\n/3m'..msg.to.id..'\n/unlimite'..msg.to.id..'\n<b>Done !</b>'
	local text_add = '<b>New Group Added</b> :\n<b>Gp Info</b> :\n<b>Gp ID </b>: <code>'..msg.to.id..'</code>\n<b>Gp name</b> : <b>'..msg.to.title..'</b>\n<i>Adder Info</i>\n<b>User ID</b> : <code>'..msg.from.id..'</code>\n<b>Username </b>: '..(msg.from.username or '')..'\n<b>You can leave the bot by</b>\n /leave'..msg.to.id..' <b>Command</b>\n\n<b>You can join it by</b> :\n /join'..msg.to.id..' <b>command</b>\n\n<b>To charge it for 1/2/3/unlimite use</b> :\n /1m'..msg.to.id..'\n/2m'..msg.to.id..'\n/3m'..msg.to.id..'\n/unlimite'..msg.to.id..'\n<b>Done !</b>'
		if matches[1] == '+' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
				return reply_msg(msg.id,"<i>SuperGroup is already added :| </i>", ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") added")
            send_msg(creed, text_add, ok_cb, false)
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end

		if matches[1]:lower() == '-' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				return reply_msg(msg.id, '<i>SuperGroup is not added. :/ </i>', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			send_msg(creed, text_rem, ok_cb, false)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end
end
		if matches[1]:lower() == "gpinfo" then
			if not is_owner(msg) then
				return
			end
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup info")
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

  --[[if matches[1] == 'rmsg' and is_owner(msg) then
    if msg.to.type == 'channel' then
      if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 1 then
        return reply_msg(msg['id'], "You Can Use [1-100] For Remove Messages", ok_cb, false)
      end
      get_history(msg.to.peer_id, matches[2] + 1 , history , {chatid = msg.to.peer_id, con = matches[2]})
    else
      return reply_msg(msg['id'], "You Can Use It Only In SuperGroup", ok_cb, false)
    end
  else
    return ""
  end]]

	if matches[1] == 'whois' and is_momod(msg) then
		local receiver = get_receiver(msg)
		local user_id = "user#id"..matches[2]
		user_info(user_id, cb_user_info, {receiver = receiver})
	end
	if not is_sudo(msg) then
		if is_realm(msg) and is_admin1(msg) then
			print("Admin detected")
		else
			return
		end
 	end



	if matches[1]:lower() == 'invite' and is_sudo(msg) then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, add_by_reply, false)
                return
            end
   if matches[1]:lower() == 'invite' and is_sudo(msg) then
                local member = string.gsub(matches[2], '@', '')
                print(chat_id)
                resolve_username(member, add_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user_id = matches[2]
                if chat_type == 'chat' then
                    chat_add_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
                elseif chat_type == 'channel' then
                    channel_invite('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
              end
            end
    end

			if matches[1] == 'list' then
			if matches[2] == 'admins' then
				return admin_list(msg)
			end
				--if matches[2] == 'support' and not matches[2] then
			--	return support_list()
		--end
		end
	
			if matches[1] == 'addadmin' then
		    if not is_sudo(msg) then-- Sudo only
				return
			end
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				return admin_promote(msg, admin_id)
			else
			    local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "addadmin"
				if msg.to.type == 'channel' then
				channel_get_users(receiver, username_id2, {mod_cmd= mod_cmd, receiver=receiver, member=member})
				else
				channel_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
				end
			end
		end
		if matches[1] == 'removeadmin' then
		    if not is_sudo(msg) then-- Sudo only
				return
			end
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				print("user "..admin_id.." has been demoted")
				return admin_demote(msg, admin_id)
			else
			local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "removeadmin"
				if msg.to.type == 'channel' then
				channel_get_users(receiver, username_id2, {mod_cmd= mod_cmd, receiver=receiver, member=member})
				else
				channel_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
				end
			end
		end
		if matches[1] == 'support' and matches[2] then
			if string.match(matches[2], '^%d+$') then
				local support_id = matches[2]
				print("User "..support_id.." has been added to the support team")
				support_add(support_id)
				return "User ["..support_id.."] has been added to the support team"
			else
				local member = string.gsub(matches[2], "@", "")
				local receiver = get_receiver(msg)
				local get_cmd = "addsupport"
				resolve_username(member, res_user_support, {get_cmd = get_cmd, receiver = receiver})
			end
		end
		if matches[1] == '-support' then
			if string.match(matches[2], '^%d+$') then
				local support_id = matches[2]
				print("User "..support_id.." has been removed from the support team")
				support_remove(support_id)
				return "User ["..support_id.."] has been removed from the support team"
			else
				local member = string.gsub(matches[2], "@", "")
				local receiver = get_receiver(msg)
				local get_cmd = "removesupport"
				resolve_username(member, res_user_support, {get_cmd = get_cmd, receiver = receiver})
			end
		end

		if matches[1]:lower() == "admins" then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
			member_type = 'Admins'
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Admins list")
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1]:lower() == "owner" and is_momod2 then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return "no owner,ask admins in support groups to set owner for your SuperGroup"
			end
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
			return "SuperGroup owner is \n@"..v.username.."\n<b> > |"..group_owner..'|</b>'
		end

		if matches[1]:lower() == "modlist" then
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group modlist")
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1]:lower() == "bots" and is_momod(msg) then
			member_type = 'Bots'
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup bots list")
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1]:lower() == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup users list")
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1]:lower() == "kicked" and is_momod(msg) then
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested Kicked users list")
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1]:lower() == 'del' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1]:lower() == 'block' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'block' and matches[2] and string.match(matches[2], '^%d+$') then
				--[[local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "You can't kick mods/owner/admins")
				end
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: [ user#id"..user_id.." ]")
				kick_user(user_id, channel_id)]]
				local get_cmd = 'channel_block'
				local msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == "block" and matches[2] and not string.match(matches[2], '^%d+$') then
			--[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'id' then
			if type(msg.reply_id) ~= "nil" and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested ID for: @"..username)
				resolve_username(username,  callbackres, cbres_extra)
			else
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup ID")
				return reply_msg(msg.id,"<b>Group id</b> : <code>-100"..msg.to.id.."</code>\n<b>Your id</b> : <code>"..msg.from.id.."</code>\n<b>Your Name</b> : <code>"..msg.from.first_name.."</code>",ok_cb,false)
			end
		end

		if matches[1]:lower() == 'kickme' then
			if msg.to.type == 'channel' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] left via kickme")
				channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
			end
		end

	if matches[1]:lower() == 'reload' then
		receiver = get_receiver(msg)
		reload_plugins(true)
		post_msg(receiver, "", ok_cb, false)
		return "<b>Done</b>\n<i>Segreto Bot</i> <i>Reloaded!</i>"
	end

		if matches[1]:lower() == 'newlink' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, '<b>Error: Failed to retrieve link</b> \n<i>Reason: Not creator.</i>\n\n<i>If you have the link, please use</i> <b>Setlink</b> <i>to set it</i>')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "Created a new link")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] attempted to create a new SuperGroup link")
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1]:lower() == 'setlink' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			return 'Please send the new group link now'
		end

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				return "<b>New link</b> <i>set</i>"
			end
		end

		if matches[1]:lower() == 'link' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "<i>Create a link using</i> <b>Newlink</b> <i>first!</i>\n\n<i>Or if I am not creator use</i> <b>Setlink</b> <i>to set your link</i>"
			end
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
			return "<b>Group link for :</b>\n<i>[ "..msg.to.title.." ] </i>\n\n"..group_link.." "
end

		if matches[1]:lower() == "invite" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] invited @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1]:lower() == 'res' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] resolved username: @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1]:lower() == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end

			if matches[1]:lower() == 'setadmin' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'setadmin' and matches[2] and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local get_cmd = 'setadmin'
				local msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1]:lower() == 'setadmin' and matches[2] and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
				local get_cmd = 'setadmin'
				local msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
end
		if matches[1]:lower() == 'demoteadmin' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'demoteadmin' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demoteadmin' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted admin @"..username)
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1]:lower() == 'setowner' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'setowner' and matches[2] and string.match(matches[2], '^%d+$') then
		--[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
					local text = "<code>[ "..matches[2].." ]</code> added as owner"
					return text
				end]]
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1]:lower() == 'setowner' and matches[2] and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'promote' then
		  if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "Only owner/admin can promote"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'promote' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1]:lower() == 'promote' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'mp' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "ok"
		end
		if matches[1] == 'md' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "ok"
		end

		if matches[1]:lower() == 'demote' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "Only owner/support/admin can promote"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'demote' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1]:lower() == 'demote' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1]:lower() == "setname" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..matches[2])
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..msg.to.title)
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1]:lower() == "setabout" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup description to: "..about_text)
			channel_set_about(receiver, about_text, ok_cb, false)
			return "Description has been set.\n\nSelect the chat again to see the changes."
		end

		if matches[1]:lower() == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "SuperGroup username Set.\n\nSelect the chat again to see the changes.")
				elseif success == 0 then
					send_large_msg(receiver, "Failed to set SuperGroup username.\nUsername may already be taken.\n\nNote: Username can use a-z, 0-9 and underscores.\nMinimum length is 5 characters.")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1]:lower() == 'setrules' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group rules to ["..matches[2].."]")
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set new SuperGroup photo")
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1]:lower() == 'setphoto' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] started setting new SuperGroup photo")
			return 'Please send the new group photo now'
		end

		if matches[1]:lower() == 'clean' then
			if not is_momod(msg) then
				return
			end
			if is_momod(msg) then
			if matches[2] == 'banlist' and is_momod(msg) then 
        local hash = 'banned'
        local data_cat = 'banlist'
           data[tostring(msg.to.id)][data_cat] = nil
           save_data(_config.moderation.data, data)
           send_large_msg(get_receiver(msg), "ban list Clean now")
           redis:del(hash)
     end
			if matches[2]:lower() == 'gbl' and is_sudo(msg) then 
        local hash = 'gbanned'
        local data_cat = 'gbanlist'
           data[tostring(msg.to.id)][data_cat] = nil
           save_data(_config.moderation.data, data)
           send_large_msg(get_receiver(msg), "Gban list Clean now")
           redis:del(hash)
     end
	 
			if matches[2]:lower() == 'modlist' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					return '<b>No moderator(s) in this SuperGroup.</b>'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
				return '<b>Modlist</b> has been cleaned'
			end
			if matches[2]:lower() == 'rules' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return "<b>Rules</b> have not been set"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
				return 'Rules have been cleaned'
			end
			if matches[2]:lower() == 'about' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return 'About is not set'
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
				channel_set_about(receiver, about_text, ok_cb, false)
				return "About has been cleaned"
			end
			if matches[2]:lower() == 'mutelist' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				return "<b>Mutelist</b> Cleaned"
			end
			if matches[2]:lower() == 'username' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "SuperGroup username cleaned.")
					elseif success == 0 then
						send_large_msg(receiver, "Failed to clean SuperGroup username.")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
			if matches[2]:lower() == "bots" and is_momod(msg) then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked all SuperGroup bots")
				channel_get_bots(receiver, callback_clean_bots, {msg = msg})
			end
		end
            if matches[2] == "members" and is_sudo(msg) then
                --savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked all SuperGroup members")
                channel_get_users(receiver, callback_clean_members, {msg = msg})
         end
            if matches[2] == "deleted" and is_momod(msg) then
                --savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked all SuperGroup Deleted Accounts !")
                channel_get_users(receiver, check_member_super_deleted,{receiver = receiver, msg = msg})
         end
		end


		if matches[1]:lower() == 'lock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2]:lower() == 'links' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked link posting ")
				return lock_group_links(msg, data, target)
			end
			if matches[2]:lower() == 'spam' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked spam ")
				return lock_group_spam(msg, data, target)
			end
			if matches[2]:lower() == 'flood' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked flood ")
				return lock_group_flood(msg, data, target)
			end
			if matches[2]:lower() == 'persian' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_arabic(msg, data, target)
			end
			if matches[2]:lower() == 'cmds' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_cmd(msg, data, target)
			end			
                         if matches[2]:lower() == 'tag' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked tag ")
				return lock_group_tag(msg, data, target)
			end
                         if matches[2]:lower() == 'forward' then
                                 --savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fwd ")
                                 return lock_group_fwd(msg, data, target)
                         end
                         if matches[2]:lower() == 'hashtag' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked hashtag ")
				return lock_group_hashtag(msg, data, target)
			end
                         if matches[2]:lower() == 'reply' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked reply ")
				return lock_group_reply(msg, data, target)
			end
			if matches[2]:lower() == 'member' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked member ")
				return lock_group_membermod(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end
			if matches[2]:lower() == 'service' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Tgservice Actions")
				return lock_group_tgservice(msg, data, target)
			end

			if matches[2]:lower() == 'sticker' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2]:lower() == 'badword' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked badword Actions")
				return lock_group_badword(msg, data, target)
			end

			if matches[2]:lower() == 'emoji' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked emoji posting")
				return lock_group_emoji(msg, data, target)
			end
			if matches[2]:lower() == 'contacts' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked contact posting")
				return lock_group_contacts(msg, data, target)
			end
			if matches[2]:lower() == 'strict' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
			
		end

		if matches[1]:lower() == 'unlock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2]:lower() == 'links' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked link posting")
				return unlock_group_links(msg, data, target)
			end
			if matches[2]:lower() == 'badword' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked badword posting")
				return unlock_group_badword(msg, data, target)
			end
			if matches[2]:lower() == 'emoji' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked emoji posting")
				return unlock_group_emoji(msg, data, target)
			end
			if matches[2]:lower() == 'spam' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2]:lower() == 'cmds' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return unlock_group_cmd(msg, data, target)
			end					
			if matches[2]:lower() == 'flood' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked flood")
				return unlock_group_flood(msg, data, target)
			end
			if matches[2]:lower() == 'persian' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Arabic")
				return unlock_group_arabic(msg, data, target)
			end
                        if matches[2]:lower() == 'hashtag' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked hashtag")
				return unlock_group_hashtag(msg, data, target)
			end
                        if matches[2]:lower() == 'reply' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked reply")
				return unlock_group_reply(msg, data, target)
			end
			if matches[2]:lower() == 'tag' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tag")
				return unlock_group_tag(msg, data, target)
			end
      if matches[2]:lower() == 'forward' then
        --savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fwd")
        return unlock_group_fwd(msg, data, target)
      end
			if matches[2]:lower() == 'member' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked member ")
				return unlock_group_membermod(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked RTL chars. in names")
				return unlock_group_rtl(msg, data, target)
			end
				if matches[2]:lower() == 'service' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tgservice actions")
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2]:lower() == 'sticker' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2]:lower() == 'contacts' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked contact posting")
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2]:lower() == 'strict' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
		end

		if matches[1]:lower() == 'setflood' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 5 or tonumber(matches[2]) > 20 then
				return "<i>Wrong number,range is</i> [5-20]"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
			return '<b>Flood</b> has been set to: '..matches[2]
		end
		if matches[1]:lower() == 'public' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
				return set_public_membermod(msg, data, target)
			end
			if matches[2]:lower() == 'no' then
				--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: not public")
				return unset_public_membermod(msg, data, target)
			end
		end

		if matches[1]:lower() == 'mute' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if not is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return msg_type.." has been muted"
				else
					return "SuperGroup mute "..msg_type.." is already on"
				end
			end
			if matches[2]:lower() == 'photo' then
			local msg_type = 'Photo'
				if not is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return msg_type.." has been muted"
				else
					return "SuperGroup mute "..msg_type.." is already on"
				end
			end
			if matches[2]:lower() == 'video' then
			local msg_type = 'Video'
				if not is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return msg_type.." has been muted"
				else
					return "SuperGroup mute "..msg_type.." is already on"
				end
			end
			if matches[2]:lower() == 'gifs' then
			local msg_type = 'Gifs'
				if not is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return msg_type.." have been muted"
				else
					return "SuperGroup mute "..msg_type.." is already on"
				end
			end
			if matches[2]:lower() == 'documents' then
			local msg_type = 'Documents'
				if not is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return msg_type.." have been muted"
				else
					return "SuperGroup mute "..msg_type.." is already on"
				end
			end
			if matches[2]:lower() == 'text' then
			local msg_type = 'Text'
				if not is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return msg_type.." has been muted"
				else
					return "Mute "..msg_type.." is already on"
				end
			end
			if matches[2]:lower() == 'all' then
			local msg_type = 'All'
				if not is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return "Mute "..msg_type.."  has been enabled"
				else
					return "Mute "..msg_type.." is already on"
				end
			end
		end
		if matches[1]:lower() == 'unmute' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return msg_type.." has been unmuted"
				else
					return "Mute "..msg_type.." is already off"
				end
			end
			if matches[2]:lower() == 'photo' then
			local msg_type = 'Photo'
				if is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return msg_type.." has been unmuted"
				else
					return "Mute "..msg_type.." is already off"
				end
			end
			if matches[2]:lower() == 'video' then
			local msg_type = 'Video'
				if is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return msg_type.." has been unmuted"
				else
					return "Mute "..msg_type.." is already off"
				end
			end
			if matches[2]:lower() == 'gifs' then
			local msg_type = 'Gifs'
				if is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return msg_type.." have been unmuted"
				else
					return "Mute "..msg_type.." is already off"
				end
			end
			if matches[2]:lower() == 'documents' then
			local msg_type = 'Documents'
				if is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return msg_type.." have been unmuted"
				else
					return "Mute "..msg_type.." is already off"
				end
			end
			if matches[2]:lower() == 'text' then
			local msg_type = 'Text'
				if is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute message")
					unmute(chat_id, msg_type)
					return msg_type.." has been unmuted"
				else
					return "Mute text is already off"
				end
			end
			if matches[2]:lower() == 'all' then
			local msg_type = 'All'
				if is_muted(chat_id, msg_type..': yes') then
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return "Mute "..msg_type.." has been disabled"
				else
					return "Mute "..msg_type.." is already disabled"
				end
			end
		end


		if matches[1]:lower() == "muteuser" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				muteuser = get_message(msg.reply_id, get_message_callback, {receiver = receiver, get_cmd = get_cmd, msg = msg})
			elseif matches[1] == "muteuser" and matches[2] and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
					return "["..user_id.."] removed from the muted users list"
				elseif is_owner(msg) then
					mute_user(chat_id, user_id)
					--savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
					return "["..user_id.."] added to the muted user list"
				end
			elseif matches[1]:lower() == "muteuser" and matches[2] and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

		if matches[1]:lower() == "muteslist" and is_momod(msg) then
			local chat_id = msg.to.id
			if not has_mutes(chat_id) then
				set_mutes(chat_id)
				return mutes_list(chat_id)
			end
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup muteslist")
			return mutes_list(chat_id)
		end
		if matches[1]:lower() == "mutelist" and is_momod(msg) then
			local chat_id = msg.to.id
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup mutelist")
			return muted_user_list(chat_id)
		end

		if matches[1]:lower() == 'settings' and is_momod(msg) then
			local target = msg.to.id
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup settings ")
			return show_supergroup_settingsmod(msg, target)
		end

		if matches[1]:lower() == 'rules' then
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group rules")
			return get_rules(msg, data)
		end

		if matches[1]:lower() == 'help' and is_momod(msg) then
			text = "It's Special for Owners and Admins . if you want to see my Commands Please send the /help to my Private"
			reply_msg(msg.id, text, ok_cb, false)
		elseif matches[1] == 'help' and is_owner(msg) then
			local name_log = user_print_name(msg.from)
			--savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /superhelp")
			return super_help()
		end

		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					--savelog(msg.to.id, name_log.." Admin ["..msg.from.id.."] joined the SuperGroup via link")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					--savelog(msg.to.id, name_log.." Support member ["..msg.from.id.."] joined the SuperGroup")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					--savelog(msg.to.id, name_log.." Admin ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					--savelog(msg.to.id, name_log.." Support member ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'SegretoTM' then
			post_large_msg(receiver, msg.to.peer_id)
		end
end
local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^(+)$",
	"^(-)$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Gg]pinfo)$",
	"^[#!/]([Aa]dmins)$",
	"^[#!/]([Oo]wner)$",
	"^[#!/]([Mm]odlist)$",
	"^[#!/]([Bb]ots)$",
	"^[#!/]([Ww]ho)$",
	"^[#!/]([Kk]icked)$",
        "^[#!/]([Bb]lock) (.*)",
	"^[#!/]([Bb]lock)",
        "^[#!/]([Kk]ick) (.*)",
	"^[#!/]([Kk]ick)",
	"^[#!/]([Tt]osuper)$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Nn]ewlink)$",
	"^[#!/]([Ss]etlink)$",
	"^[#!/]([Ll]ink)$",
	"^[#!/]([Rr]es) (.*)$",
	"^[#!/]([Ss]etadmin) (.*)$",
	"^[#!/]([Ss]etadmin)",
	"^[#!/]([Dd]emoteadmin) (.*)$",
	"^[#!/]([Dd]emoteadmin)",
	"^[#!/]([Ss]etowner) (.*)$",
	"^[#!/]([Ss]etowner)$",
	"^[#!/]([Pp]romote) (.*)$",
	"^[#!/]([Pp]romote)",
	"^[#!/]([Dd]emote) (.*)$",
	"^[#!/]([Dd]emote)",
	"^[#!/]([Ss]etname) (.*)$",
	"^[#!/]([Ss]etabout) (.*)$",
	"^[#!/]([Ss]etrules) (.*)$",
	"^[#!/]([Ss]etphoto)$",
	"^[#!/]([Ss]etusername) (.*)$",
	"^[#!/]([Dd]el)$",
	"^[#!/]([Ll]ock) (.*)$",
	"^[#!/]([Uu]nlock) (.*)$",
	"^[#!/]([Mm]ute) ([^%s]+)$",
	"^[#!/]([Uu]nmute) ([^%s]+)$",
	"^[#!/]([Mm]uteuser)$",
	"^[#!/]([Mm]uteuser) (.*)$",
	"^[#!/]([Pp]ublic) (.*)$",
	"^[#!/]([Ss]ettings)$",
	"^[#!/]([Rr]ules)$",
	"^[#!/]([Ss]etflood) (%d+)$",
	"^[#!/]([Cc]lean) (.*)$",
	"^[/!#]([Ss]egretoTM)",
	"^[#!/]([Mm]uteslist)$",
	"^[#!/]([Mm]utelist)$",
        "^[#!/](mp) (.*)",
	"^[#!/](md) (.*)",
	"^[/!#]([Uu]nlimite)(%d+)(.*)$",
        "^[/!#]([Uu]nlimite)(%d+) (.*)$",
        "^[/!#]([Uu]nlimite)(%d+)$",
        "^[/!#]([Ll]eave)(%d+) (.*)$",
        "^[/!#]([Ll]eave)(%d+)(.*)$",
        "^[/!#]([Ll]eave)(%d+)$",
        "^[/!#]([Ll]eave)$",
        "^[/!#]([Jj]oin)(%d+)$",
        "^[/!#](3[Mm])(%d+)(.*)$",
        "^[/!#](3[Mm])(%d+) (.*)$",
        "^[/!#](3[Mm])(%d+)$",
        "^[/!#](1[Mm])(%d+)(.*)$",
        "^[/!#](1[Mm])(%d+) (.*)$",
        "^[/!#](1[Mm])(%d+)$",
        "^[/!#]([Jj]oin)(%d+)$",
	"^([Mm]ove) (.*)$",
	"^([Gg]pinfo)$",
	"^([Aa]dmins)$",
	"^([Oo]wner)$",
	"^([Mm]odlist)$",
	"^([Bb]ots)$",
	"^([Ww]ho)$",
	"^([Kk]icked)$",
        "^([Bb]lock) (.*)",
	"^([Bb]lock)",
        "^([Kk]ick) (.*)",
	"^([Kk]ick)",
	"^([Tt]osuper)$",
	"^([Ii][Dd]) (.*)$",
	"^([Ii][Dd])$",
	"^([Nn]ewlink)$",
	"^([Ss]etlink)$",
	"^([Ll]ink)$",
	"^([Rr]es) (.*)$",
	"^([Ss]etadmin) (.*)$",
	"^([Ss]etadmin)",
	"^([Dd]emoteadmin) (.*)$",
	"^([Dd]emoteadmin)",
	"^([Ss]etowner) (.*)$",
	"^([Ss]etowner)$",
	"^([Pp]romote) (.*)$",
	"^([Pp]romote)",
	"^([Dd]emote) (.*)$",
	"^([Dd]emote)",
	"^([Ss]etname) (.*)$",
	"^([Ss]etabout) (.*)$",
	"^([Ss]etrules) (.*)$",
	"^([Ss]etphoto)$",
	"^([Ss]etusername) (.*)$",
	"^([Dd]el)$",
	"^([Ll]ock) (.*)$",
	"^([Uu]nlock) (.*)$",
	"^([Mm]ute) ([^%s]+)$",
	"^([Uu]nmute) ([^%s]+)$",
	"^([Mm]uteuser)$",
	"^([Mm]uteuser) (.*)$",
	"^([Pp]ublic) (.*)$",
	"^([Ss]ettings)$",
   "^([Ss]egretoTM)"
	"^([Rr]ules)$",
	"^([Ss]etflood) (%d+)$",
	"^([Cc]lean) (.*)$",
	"^([Mm]uteslist)$",
	"^([Mm]utelist)$",
        "^(mp) (.*)",
	"^(md) (.*)",
	"^([Uu]nlimite)(%d+)(.*)$",
        "^([Uu]nlimite)(%d+) (.*)$",
        "^([Uu]nlimite)(%d+)$",
        "^([Ll]eave)(%d+) (.*)$",
        "^([Ll]eave)(%d+)(.*)$",
        "^([Ll]eave)(%d+)$",
        "^([Ll]eave)$",
        "^([Jj]oin)(%d+)$",
        "^(3[Mm])(%d+)(.*)$",
        "^(3[Mm])(%d+) (.*)$",
        "^(3[Mm])(%d+)$",
        "^(1[Mm])(%d+)(.*)$",
        "^(1[Mm])(%d+) (.*)$",
        "^(1[Mm])(%d+)$",
        "^([Jj]oin)(%d+)$",
        "^(https://telegram.me/joinchat/%S+)$",
	"^([Ww]hois) (.*)",
       "^(list) (.*)$",
       "^(addadmin) (.*)$", -- sudoers only
        "^(removeadmin) (.*)$", -- sudoers only
	"^(support)$",
	"^(support) (.*)$",
        "^(-support) (.*)$",
	"^[#/!](reload)$",	
        --"^[#!/](rmsg) (%d*)$",
	"^[#/](invite)$",
	"^[#/](invite) (.*)$",
	"^(invite)$",
	"^(invite) (.*)$",
   -----------banhammer
   --"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = run,
  pre_process = pre_process
}

--[[

     
            SEGRETO         
                             
          By @PrswShrr       
                             
       Channel > @Segreto_Ch 
     
	 
]]
