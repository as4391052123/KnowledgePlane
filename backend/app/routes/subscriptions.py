from fastapi import APIRouter, HTTPException
from backend.app.services.subscription_config import SubscriptionConfig

router = APIRouter()
config = SubscriptionConfig()

@router.get("/subscriptions")
def get_all_subscriptions():
    """获取所有订阅配置"""
    return config.get_all()

@router.get("/subscriptions/{name}")
def get_subscription_by_name(name: str):
    """根据名称获取订阅配置"""
    subscription = config.get_by_name(name)
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    return subscription

@router.post("/subscriptions")
def update_subscriptions(new_config: dict):
    """更新订阅配置"""
    updated_config = config.update(new_config)
    return {"status": "success", "updated_config": updated_config}
