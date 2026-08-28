import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from orders.order import Order, OrderStatus


def test_add_item():
    order = Order(order_id="ord-1")
    order.add_item("sku-1", 2)
    assert order.items == [{"sku": "sku-1", "quantity": 2}]


def test_add_item_rejects_non_positive_quantity():
    order = Order(order_id="ord-1")
    try:
        order.add_item("sku-1", 0)
        assert False, "expected ValueError"
    except ValueError:
        pass


def test_ship_requires_items():
    order = Order(order_id="ord-1")
    try:
        order.ship()
        assert False, "expected ValueError"
    except ValueError:
        pass


def test_ship_sets_status():
    order = Order(order_id="ord-1")
    order.add_item("sku-1", 1)
    order.ship()
    assert order.status == OrderStatus.SHIPPED
