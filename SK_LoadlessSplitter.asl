// Shady Knight loadless autosplitter 
// by Supahsemmie with help from Seemmetor
// asl-help by Ero (https://github.com/just-ero/asl-help)

state("Shady Knight"){
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Shady Knight";
    vars.Helper.LoadSceneManager = true;
    

    vars.MissionStates = new ExpandoObject();
        vars.MissionStates.Intro = 0;
        vars.MissionStates.InProcess = 1;
        vars.MissionStates.Complete = 2;

    settings.Add("Autoreset", true, "Enable auto reset");

    vars.Helper.AlertLoadless();
}   

init
{
       vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["MissionState"] = mono.Make<int>("Game", "mission", "state");
        vars.Helper["InputsActive"] = mono.Make<bool>("Game", "player", "inputActive");

	    return true;
    });
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
}

start 
{
    // stylehunt2 denotes the practice arena
    return current.MissionState == vars.MissionStates.Intro 
    && current.activeScene != "MainMenu"  
    && current.activeScene != "Loading Screen" 
    && current.activeScene != "stylehunt2";
}


split 
{   
    // Final split as you lose control and break the door in IntroScene3/final hallway
    if (current.activeScene == "IntroScene3" && !current.InputsActive && old.InputsActive) 
        return true;
    return old.MissionState == vars.MissionStates.InProcess 
    && current.MissionState == vars.MissionStates.Complete;
}

reset 
{   
    // Resets any UNCOMPLETED run by going back to the main menu, toggleable in livesplit
    if (settings["Autoreset"])
    {
        return current.activeScene == "MainMenu" 
        && old.activeScene != "MainMenu";
    }
    return false;   
    
}

isLoading {
    return current.activeScene != current.loadingScene;
}
