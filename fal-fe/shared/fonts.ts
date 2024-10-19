export const Fonts = {
    Protest_Guerrilla: 'Protest Guerrilla',
    Roboto_Slab: 'Roboto Slab',
    Playwrite_England_SemiJoined: 'Playwrite GB S',
    Libre_Baskerville: 'Libre Baskerville'
}

export const FontSetup = () => {
    document.documentElement.style.setProperty('--Protest-Guerrilla', Fonts.Protest_Guerrilla)
    document.documentElement.style.setProperty('--Roboto-Slab', Fonts.Roboto_Slab)
    document.documentElement.style.setProperty('--Playwrite-England-SemiJoined', Fonts.Playwrite_England_SemiJoined)
    document.documentElement.style.setProperty('--Libre-Baskerville', Fonts.Libre_Baskerville)
}