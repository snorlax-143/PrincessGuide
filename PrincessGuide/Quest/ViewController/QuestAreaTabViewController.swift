//
//  QuestAreaTabViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import Gestalt

class QuestAreaTabViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    private var viewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Quests", comment: "")
        viewControllers = [DungeonBossTableViewController(), HatsuneEventAreaTableViewController(), ClanBattleTableViewController(), TowerTableViewController(), QuestAreaTableViewController(areaType: .normal), QuestAreaTableViewController(areaType: .hard), ]
        dataSource = self
        bar.items = [
            Item(title: NSLocalizedString("Dungeon", comment: "")),
            Item(title: NSLocalizedString("Event", comment: "")),
            Item(title: NSLocalizedString("Clan Battle", comment: "")),
            Item(title: NSLocalizedString("Tower", comment: ""))
            ] + [AreaType.normal, .hard].map { Item(title: $0.description) }
        
        bar.location = .bottom

        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            
            themeable.view.backgroundColor = theme.color.background
            themeable.bar.appearance = TabmanBar.Appearance({ (appearance) in
                appearance.indicator.color = theme.color.tint
                appearance.state.selectedColor = theme.color.tint
                appearance.state.color = theme.color.lightText
                appearance.layout.itemDistribution = .centered
                appearance.style.background = .blur(style: theme.blurEffectStyle)
                appearance.indicator.preferredStyle = .clear
            })
        }
        
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 2)
    }
    
}
