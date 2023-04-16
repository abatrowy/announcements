#include <sourcemod>
#include <sdktools>
#include <sdktools_sound>

#pragma newdecls required
#pragma semicolon 1

Handle WelcomeSound		= INVALID_HANDLE;
Handle WelcomeSoundFile		= INVALID_HANDLE;

Handle ConnectSound		= INVALID_HANDLE;
Handle ConnectSoundFile		= INVALID_HANDLE;

Handle DisconnectSound		= INVALID_HANDLE;
Handle DisconnectSoundFile		= INVALID_HANDLE;

Handle DeathSound		= INVALID_HANDLE;
Handle DeathSoundFile		= INVALID_HANDLE;

int playerdeath[MAXPLAYERS +1];

public Plugin myinfo =
{
	name = "abatrowy's announcements for csgo",
	author = "abatrowy",
	description = "welcome, connect, death, disconnect sound announcements",
	version = "1.0",
	url = "/id/abatrowy"
};

public void OnPluginStart()
{
	//LoadTranslations( "abatrowy_announcements.phrases" ); - na pozniej

	WelcomeSound		=	CreateConVar( "sounds_welcome", 	"1",	   "Toggles welcome sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	WelcomeSoundFile	=	CreateConVar( "sounds_welcome_sound_file",	   "instasity/wejsciowki/dolaczenie.mp3", "Sound location of welcome sound" );
	ConnectSound		=	CreateConVar( "sounds_connect", 	"1",	   "Toggles connect sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	ConnectSoundFile	=	CreateConVar( "sounds_connect_sound_file",	   "instasity/wejsciowki/wejscie.mp3", "Sound location of connect sound" );
	DisconnectSound		=	CreateConVar( "sounds_disconnect", 	"1",	   "Toggles disconnect sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	DisconnectSoundFile	=	CreateConVar( "sounds_disconnect_sound_file",  "instasity/wejsciowki/wyjscie.mp3", "Sound location of disconnect" );

	DeathSound		=	CreateConVar( "sounds_death", 	"1",	   "Toggles death sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	DeathSoundFile	=	CreateConVar( "sounds_death_sound_file",  "instasity/inne/zgon.mp3", "Sound location of death" );
	
	HookEvent("player_death", OnDeath);

	AutoExecConfig(true, "abatrowy_announcements");
}

public void OnConfigsExecuted()
{
	if(GetConVarInt(WelcomeSound) == 1)
	{
		char welcome[PLATFORM_MAX_PATH];
		GetConVarString(WelcomeSoundFile, welcome, sizeof(welcome));
		if(!StrEqual(welcome, ""))
		{
			char download[PLATFORM_MAX_PATH];
			Format(download, sizeof(download), "sound/%s", welcome);
			AddFileToDownloadsTable(download);
			PrecacheSound(welcome);
		}
	}
	if(GetConVarInt(DisconnectSound) == 1)
	{
		char disconnect[PLATFORM_MAX_PATH];
		GetConVarString(DisconnectSoundFile, disconnect, sizeof(disconnect));
		if(!StrEqual(disconnect, ""))
		{
			char download2[PLATFORM_MAX_PATH];
			Format(download2, sizeof(download2), "sound/%s", disconnect);
			AddFileToDownloadsTable(download2);
			PrecacheSound(disconnect);
		}
	}
	if(GetConVarInt(ConnectSound) == 1)
	{
		char connect[PLATFORM_MAX_PATH];
		GetConVarString(ConnectSoundFile, connect, sizeof(connect));
		if(!StrEqual(connect, ""))
		{
			char download3[PLATFORM_MAX_PATH];
			Format(download3, sizeof(download3), "sound/%s", connect);
			AddFileToDownloadsTable(download3);
			PrecacheSound(connect);
		}
	}
	if(GetConVarInt(DeathSound) == 1)
	{
		char death[PLATFORM_MAX_PATH];
		GetConVarString(DeathSoundFile, death, sizeof(death));
		if(!StrEqual(death, ""))
		{
			char download4[PLATFORM_MAX_PATH];
			Format(download4, sizeof(download4), "sound/%s", death);
			AddFileToDownloadsTable(download4);
			PrecacheSound(death);
		}
	}
}

public void OnClientPostAdminCheck(int client)
{
	char connect[PLATFORM_MAX_PATH];
	GetConVarString(ConnectSoundFile, connect, sizeof(connect));

	if(GetConVarInt(ConnectSound) == 1)
	{
		for (int i = 1; i <= MaxClients; ++i)
		{
          if (i == client || !IsClientInGame(i))
		  continue;

          EmitSoundToClient(i, connect);
		}
	}

	char welcome[PLATFORM_MAX_PATH];
	GetConVarString(WelcomeSoundFile, welcome, sizeof(welcome));

	if (GetConVarInt(WelcomeSound) == 1 && IsClientInGame(client))
    EmitSoundToClient(client, welcome);
}

public void OnClientDisconnect(int client)
{
	char disconnect[PLATFORM_MAX_PATH];
	GetConVarString(DisconnectSoundFile, disconnect, sizeof(disconnect));

	if(GetConVarInt(DisconnectSound) == 1)
	{
		EmitSoundToAll(disconnect); // disconnect sound
	}
}

public void OnDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	char death[PLATFORM_MAX_PATH];
	GetConVarString(DeathSoundFile, death, sizeof(death));
	playerdeath[client] += 1;
	if(GetConVarInt(DeathSound) == 1)
	{
		if (playerdeath[client] == 2)
		{
			EmitSoundToClient(client, death);
			playerdeath[client] = 0;
		}
	}
}