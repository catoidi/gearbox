/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
 *
 * This file is part of Gearbox.
 *
 * Gearbox is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Gearbox is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Gearbox.  If not, see <https://www.gnu.org/licenses/>.
 */

class gb_InventoryMenu
{

  static
  gb_InventoryMenu from()
  {
    let result = new("gb_InventoryMenu");
    result.mSelectedIndex = 0;
    return result;
  }

  string confirmSelection() const
  {
    let item  = players[consolePlayer].mo.inv;
    int index = 0;
    while (item != NULL)
    {
      if (item.bInvBar)
      {
        if (index == mSelectedIndex) return item.getClassName();
        ++index;
      }
      item = item.inv;
    }

    return "";
  }

  ui
  void selectNext()
  {
    mSelectedIndex = (mSelectedIndex + 1) % getItemsNumber();
  }

  ui
  void selectPrev()
  {
    int nItems = getItemsNumber();
    mSelectedIndex = (mSelectedIndex - 1 + nItems) % nItems;
  }

  ui
  void setSelectedIndex(int index)
  {
    if (index == -1) return;

    mSelectedIndex = index;
  }

  ui
  int getSelectedIndex() const
  {
    return mSelectedIndex;
  }

  ui
  void fill(out gb_ViewModel viewModel)
  {
    let item  = players[consolePlayer].mo.inv;
    int index = 0;
    while (item != NULL)
    {
      if (item.bInvBar)
      {
        string tag = item.getTag();
        viewModel.tags    .push(tag);
        viewModel.slots   .push(index + 1);
        viewModel.indices .push(index);
        viewModel.icons   .push(int(StatusBar.GetInventoryIcon(item, StatusBar.DI_ALTICONFIRST)));
        viewModel.ammo1   .push(item.amount);
        viewModel.maxAmmo1.push(item.maxAmount);
        viewModel.ammo2   .push(-1);
        viewModel.maxAmmo2.push(-1);

        ++index;
      }
      item = item.inv;
    }

    mSelectedIndex = min(mSelectedIndex, getItemsNumber());
    viewModel.selectedWeaponIndex = mSelectedIndex;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  int getItemsNumber()
  {
    let item   = players[consolePlayer].mo.inv;
    int result = 0;
    while (item != NULL)
    {
      result += item.bInvBar;
      item = item.inv;
    }
    return result;
  }

  private int mSelectedIndex;

} // class gb_InventoryMenu
