import com.GameInterface.Browser.Browser;
import com.GameInterface.DistributedValue;
import com.GameInterface.TradepostSearchResultData;
import mx.utils.Delegate;

class com.xeio.SwlMarket.MarketApi
{
    var m_Browser:Browser;
    var m_itemsToSubmit:Array = [];
    var m_lastSentItem:TradepostSearchResultData;
    var m_browserStuckTimeout:Number;
    var m_submitTimeout:Number;
    
    public function MarketApi()
    {
        
    }
    
    public function QueuePriceSubmit(newPrice: TradepostSearchResultData)
    {
        m_itemsToSubmit.push(newPrice);
        
        if(!m_Browser)
        {
            clearTimeout(m_submitTimeout);
            m_submitTimeout = setTimeout(Delegate.create(this, Upload), 1000);
        }
    }
    
    private function Upload()
    {
        if (!m_Browser)
        {
            m_Browser = new Browser(18, 100, 100);
            m_Browser.SignalBrowserShowPage.Connect(PageLoaded,  this);
        }
        
        m_lastSentItem = TradepostSearchResultData(m_itemsToSubmit.pop());
        if (!m_lastSentItem)
        {
            m_Browser.CloseBrowser();
            m_Browser = undefined;
            return;
        }
        
        var url:String = DistributedValue.GetDValue("SwlMarket_Url") +
                            "/api/PriceUpload?name=" + escape(m_lastSentItem.m_Item.m_Name) +
                            "&price=" + m_lastSentItem["u_price"] +
                            "&expiresIn=" + m_lastSentItem.m_ExpireDate +
                            "&rarity=" + m_lastSentItem.m_Item.m_Rarity +
                            "&category=" + m_lastSentItem.m_Item.m_ItemTypeGUI +
                            "&ext=" + (m_lastSentItem.m_Item.m_ColorLine == 43); //Extraordinary
        
        m_Browser.OpenURL(url);
        
        clearTimeout(m_browserStuckTimeout);
        m_browserStuckTimeout = setTimeout(Delegate.create(this, Timeout), 10000);
    }
    
    public function PageLoaded()
    {
        clearTimeout(m_browserStuckTimeout);
        m_Browser.Stop();
        
        if (this.m_itemsToSubmit.length == 0)
        {
            m_Browser.CloseBrowser();
            m_Browser = undefined;
        }
        else
        {
            clearTimeout(m_submitTimeout);
            m_submitTimeout = setTimeout(Delegate.create(this, Upload), 1000);
        }
    }
    
    public function Timeout()
    {
        m_Browser.Stop();
        m_Browser.SignalBrowserShowPage.Disconnect(PageLoaded, this);
        m_Browser.CloseBrowser();
        m_Browser = undefined;
        
        QueuePriceSubmit(m_lastSentItem);
    }
}