"""Order domain model.

Pre-existing brownfield code: created before MDPE was adopted on this
repository. No framework dependency - plain Python domain object.
"""

from dataclasses import dataclass, field
from enum import Enum


class OrderStatus(Enum):
    CREATED = "created"
    SHIPPED = "shipped"
    CANCELLED = "cancelled"


@dataclass
class Order:
    order_id: str
    items: list = field(default_factory=list)
    status: OrderStatus = OrderStatus.CREATED

    def add_item(self, sku: str, quantity: int) -> None:
        if quantity <= 0:
            raise ValueError("quantity must be positive")
        self.items.append({"sku": sku, "quantity": quantity})

    def ship(self) -> None:
        if not self.items:
            raise ValueError("cannot ship an order with no items")
        self.status = OrderStatus.SHIPPED

    def cancel(self) -> None:
        if self.status == OrderStatus.SHIPPED:
            raise ValueError("cannot cancel a shipped order")
        self.status = OrderStatus.CANCELLED
