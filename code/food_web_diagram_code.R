# ESIIL Summit - Food web code
# Ruby Krasnow
# Last updated: 2025-09-25

# Food web ----------------------------------------------------------------

library(DiagrammeR)


# Version 3 ---------------------------------------------------------------

grViz("
digraph foodweb {
  graph [rankdir=TB, nodesep=0.5, ranksep=0.6, compound=true]
  node  [fontname=Helvetica, fontsize=11, shape=rect, style=filled]
  edge  [arrowsize=0.8]

  // ----------------------------
  // Piscivorous cluster (anchor centered)
  // ----------------------------
  subgraph cluster_pisc {
    label    = ' Piscivorous fish'
    labeljust = 'l'
    color    = '#1E429F'
    penwidth = 3
    style    = 'rounded, dashed'
    fontname = Helvetica
    fontsize = 14

    Walleye      [label='Walleye',      fillcolor='#D8EAFE']
    Salmon       [label='Salmon',       fillcolor='#D8EAFE']
    LakeTrout    [label='Lake Trout',   fillcolor='#D8EAFE']
    YellowPerch  [label='Yellow Perch', fillcolor='#D8EAFE']
    Burbot       [label='Burbot',       fillcolor='#D8EAFE']

    // tiny invisible anchor
    pisc_anchor  [label='', shape=point, width=0.01, style=invis]

    // same rank + invisible chain with anchor in the middle => centered
    {rank=same; Walleye; Salmon; LakeTrout; pisc_anchor; YellowPerch; Burbot;}
    edge [style=invis, weight=200]
    Walleye -> Salmon -> LakeTrout -> pisc_anchor -> YellowPerch -> Burbot;
    edge [style=solid, weight=1]  // reset for rest
  }

  // ----------------------------
  // Planktivorous cluster (anchor centered)
  // ----------------------------
  subgraph cluster_plankt {
    label    = ' Planktivorous fish'
    labeljust = 'l'
    color    = '#F09BA7'
    penwidth = 3
    style    = 'rounded, dashed'
    fontname = Helvetica
    fontsize = 14

    RainbowSmelt [label='Rainbow\\nsmelt',   fillcolor='#F5C6CF']
    TroutPerch   [label='Trout–perch',      fillcolor='#F5C6CF']
    Alewife      [label='Alewife\\n(2003)',  fillcolor='#F5C6CF', color='#7A1E1E', penwidth=3]
    SlimySculpin [label='Slimy sculpin',    fillcolor='#F5C6CF']

    plank_anchor [label='', shape=point, width=0.01, style=invis]

    {rank=same; RainbowSmelt; TroutPerch; plank_anchor; Alewife; SlimySculpin;}
    edge [style=invis, weight=200]
    RainbowSmelt -> TroutPerch -> plank_anchor -> Alewife -> SlimySculpin;
    edge [style=solid, weight=1]
  }

  // ----------------------------
  // Other nodes
  // ----------------------------
  SeaLamprey    [label='Sea lamprey', fillcolor='#DDDDDD']
  Mysids        [label='Mysids',     fillcolor='#FFF7CC']
  Copepods      [label='Copepods',   fillcolor='#FFF7CC']
  Cladocera     [label='Cladocera',  fillcolor='#FFF7CC']
  Rotifers      [label='Rotifers',   fillcolor='#FFF7CC']
  Phytoplankton [label='Phytoplankton', fillcolor='#A7E3D7']
  InvasiveFleas [label='Invasive water\\nfleas (2014, 2018)', fillcolor='#FFF7CC',
                 color='#7A1E1E', penwidth=3]
  Watermilfoil  [label='Eurasian\\nwatermilfoil (2009)', fillcolor='#A7E3D7', color='#7A1E1E', penwidth=3]
  ZebraMussel   [label='Zebra\\nmussel (1993)', fillcolor='#DDDDDD',
                 color='#7A1E1E', penwidth=3]

  // =========================
  // 3) EDGES (AFTER CLUSTERS)
  // =========================
  // cluster-to-cluster
  pisc_anchor   -> plank_anchor

  // from planktivore cluster to middle levels
  plank_anchor  -> Mysids
  plank_anchor  -> Copepods
  plank_anchor  -> InvasiveFleas

  // middle-level dynamics
  Mysids        -> Cladocera
  Copepods      -> Rotifers
  Rotifers      -> Cladocera
  InvasiveFleas -> Cladocera
  
  // Invisible edges for formatting
  {rank=same; Watermilfoil -> Phytoplankton [style='invis']}
  Cladocera -> Phytoplankton
  {rank=same; Phytoplankton -> ZebraMussel [style='invis']}

}
")



# Version 2 - with species combined --------------------------------

grViz("
digraph foodweb {
  graph [rankdir=TB, nodesep=0.4, ranksep=0.5]
  node  [fontname = Helvetica, fontsize = 11,
         shape = rectangle, style = filled]
  
  # DEFINE SPECIES
  # Top predators
  YellowPerch [label = 'Yellow Perch', fillcolor = '#BBDEFB']  # light blue
  LakeTrout   [label = 'Lake Trout',   fillcolor = '#BBDEFB']
  Salmon      [label = 'Salmon',       fillcolor = '#BBDEFB']
  Walleye     [label = 'Walleye',      fillcolor = '#BBDEFB']
  Burbot      [label = 'Burbot',       fillcolor = '#BBDEFB']
  SeaLamprey  [label = 'Sea Lamprey',  fillcolor = '#BBDEFB']

  # Planktivores
  TroutPerch [label = 'Trout-perch', fillcolor = '#7bacab']
  Sculpin    [label = 'Slimy Sculpin', fillcolor = '#7bacab']
  RainbowSmelt [label = 'Rainbow Smelt', fillcolor = '#7bacab']

  # Zooplankton
  Mysids      [label = 'Mysids', fillcolor = '#ffeead']
  Leptodora   [label = 'Leptodora', fillcolor = '#ffeead']
  Cladocera   [label = 'Cladocera', fillcolor = '#ffeead']
  Cope    [label = 'Copepods', fillcolor = '#ffeead']
  Rotifers    [label = 'Rotifers', fillcolor = '#ffeead']

  # Phytoplankton/algae
  Chlorophyta   [label = 'Chlorophyta\\n(green algae)', fillcolor = '#E8F5E9']
  Chrysophyta   [label = 'Chrysophyta\\n(diatoms)', fillcolor = '#E8F5E9']
  Phyphoto      [label = 'Phyphoto', fillcolor = '#E8F5E9']

  # Other invaders / influences
  WF [label = 'Invasive Water Fleas\\n(2014, 2018)', fillcolor = '#ffeead', color = '#950606', penwidth = 2]
  Watermilfoil [label = 'Water milfoil\\n(2009)', fillcolor = '#E8F5E9', color = '#950606', penwidth = 2]
  ZebraMussel  [label = 'Zebra Mussel\\n(1993)', fillcolor = '#E8F5E9', color = '#950606', penwidth = 2]
    Alewife    [label = 'Alewife\\n(2003)', fillcolor = '#7bacab', color = '#950606', penwidth = 2]

  # EDGES
  # Salmon -> Alewife
  # Walleye -> YellowPerch
  # Walleye -> TroutPerch
  # YellowPerch -> RainbowSmelt
  # YellowPerch -> Alewife
  # LakeTrout -> Alewife
  pisc_anchor -> planktivore_anchor
  planktivore_anchor -> {Mysids Leptodora Cope WF}
  Mysids   -> Cladocera
  Mysids   -> Cope
  Leptodora-> Cladocera
  Leptodora-> Rotifers
  Cope -> Rotifers
  
  Rotifers -> {Chlorophyta Chrysophyta Phyphoto}
  Cladocera-> {Chlorophyta Chrysophyta Phyphoto}

  # Side interactions / invasives
 # YellowPerch -> WF
  WF -> Leptodora
  ZebraMussel -> {Chlorophyta Chrysophyta Phyphoto}
  
  # Phytoplankton
  Chlorophyta [label = 'Chlorophyta\\n(green algae)', fillcolor = '#E8F5E9']
  Chrysophyta [label = 'Chlorophyta\\n(diatoms)', fillcolor = '#E8F5E9']
  Phyphoto
  
  # ---- Cluster for Piscivorous Fish ----
  subgraph cluster_piscivores {
    label = 'Piscivorous Fish'
    color = '#1E88E5'
    style = 'rounded,dashed'
    penwidth = 2
    fontname = Helvetica
    fontsize = 12

    YellowPerch
    Salmon
    LakeTrout
    Walleye
    Burbot
    SeaLamprey
    
    # invisible anchor node used for edges to/from the cluster
    pisc_anchor [label=\"\", shape=point, width=0.01, style=invis]
  }
  
  subgraph cluster_planktivores {
    label = 'Planktivorous Fish'
    color = '#7bacab'
    style = 'rounded,dashed'
    penwidth = 2
    fontname = Helvetica
    fontsize = 12

    TroutPerch
    Sculpin
    Alewife
    RainbowSmelt
  
    planktivore_anchor [label=\"\", shape=point, width=0.01, style=invis]
  }
  
subgraph cluster_phytoplankton {
    label = 'Phytoplankton'
    color = '#81818e'
    style = 'rounded,dashed'
    penwidth = 2
    fontname = Helvetica
    fontsize = 12

    Chlorophyta
    Chrysophyta
    Phyphoto
  }
}
")


# Version 1 - with more individual species --------------------------------

grViz("
digraph foodweb {
  graph [rankdir=TB, nodesep=0.4, ranksep=0.5]
  node  [fontname = Helvetica, fontsize = 11,
         shape = rectangle, style = filled]
  
  # DEFINE SPECIES
  # Top predators
  YellowPerch [label = 'Yellow Perch', fillcolor = '#BBDEFB']  # light blue
  LakeTrout   [label = 'Lake Trout',   fillcolor = '#BBDEFB']
  Salmon      [label = 'Salmon',       fillcolor = '#BBDEFB']
  Walleye     [label = 'Walleye',      fillcolor = '#BBDEFB']
  Burbot      [label = 'Burbot',       fillcolor = '#BBDEFB']
  SeaLamprey  [label = 'Sea Lamprey',  fillcolor = '#BBDEFB']

  # Planktivores
  TroutPerch [label = 'Trout-perch', fillcolor = '#7bacab']
  Sculpin    [label = 'Slimy Sculpin', fillcolor = '#7bacab']
  Alewife    [label = 'Alewife\\n(2003)', fillcolor = '#7bacab']
  RainbowSmelt [label = 'Rainbow Smelt', fillcolor = '#7bacab']

  # Zooplankton
  Mysids      [label = 'Mysids',      fillcolor = '#E8F5E9']
  Leptodora   [label = 'Leptodora',   fillcolor = '#E8F5E9']
  Cladocera   [label = 'Cladocera',   fillcolor = '#e5b536']
  PredCope    [label = 'Predator Copepods', fillcolor = '#E8F5E9']
  HerbCope    [label = 'Herbivorous Copepods', fillcolor = '#E8F5E9']
  Rotifers    [label = 'Rotifers',    fillcolor = '#E8F5E9']

  # Phytoplankton/algae
  Chlorophyta   [label = 'Chlorophyta\\n(green algae)', fillcolor = '#E8F5E9']
  Chrysophyta   [label = 'Chrysophyta\\n(diatoms)', fillcolor = '#E8F5E9']
  Phyphoto      [label = 'Phyphoto', fillcolor = '#E8F5E9']

  # Other invaders / influences
  RainbowSmelt [label = 'Rainbow Smelt', fillcolor = '#E8F5E9']
  SpinyWF [label = 'Spiny Water Flea\\n(2014)', fillcolor = '#ffeead', color = '#950606']
  FishhookWF [label = 'Fishhook Water Flea\\n(2018)', fillcolor = '#ffeead', color = '#950606']
  Watermilfoil [label = 'Water milfoil\\n(2009)', fillcolor = '#E8F5E9', color = '#950606']
  ZebraMussel  [label = 'Zebra Mussel\\n(1993)', fillcolor = '#E8F5E9', color = '#950606']

  # EDGES
  Salmon -> Alewife
  YellowPerch -> RainbowSmelt
  planktivore_anchor -> {Mysids Leptodora PredCope HerbCope SpinyWF}
  Mysids   -> Cladocera
  Leptodora-> Cladocera
  PredCope -> HerbCope
  HerbCope -> Rotifers
  
  Rotifers -> {Chlorophyta Chrysophyta Phyphoto}
  Cladocera-> {Chlorophyta Chrysophyta Phyphoto}

  # Side interactions / invasives
  YellowPerch -> SpinyWF
  RainbowSmelt -> SpinyWF
  SpinyWF -> Leptodora
  ZebraMussel -> {Chlorophyta Chrysophyta Phyphoto}
  
  # Phytoplankton
  Chlorophyta [label = 'Chlorophyta\\n(green algae)', fillcolor = '#E8F5E9']
  Chrysophyta [label = 'Chlorophyta\\n(diatoms)', fillcolor = '#E8F5E9']
  Phyphoto
  
  # ---- Cluster for Piscivorous Fish ----
  subgraph cluster_piscivores {
    label = 'Piscivorous Fish'
    color = '#1E88E5'
    style = 'rounded,dashed'
    penwidth = 2
    fontname = Helvetica
    fontsize = 12

    YellowPerch
    Salmon
    LakeTrout
    Walleye
    Burbot
    SeaLamprey
    
    # invisible anchor node used for edges to/from the cluster
    pisc_anchor [label=\"\", shape=point, width=0.01, style=invis]
  }
  
  subgraph cluster_planktivores {
    label = 'Planktivorous Fish'
    color = '#7bacab'
    style = 'rounded,dashed'
    penwidth = 2
    fontname = Helvetica
    fontsize = 12

    TroutPerch
    Sculpin
    Alewife
  
    planktivore_anchor [label=\"\", shape=point, width=0.01, style=invis]
  }
  
subgraph cluster_phytoplankton {
    label = 'Phytoplankton'
    color = '#81818e'
    style = 'rounded,dashed'
    penwidth = 2
    fontname = Helvetica
    fontsize = 12

    Chlorophyta
    Chrysophyta
    Phyphoto
  }
}
")
