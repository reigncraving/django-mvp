import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core import validators
from django.utils.translation import gettext_lazy as _
from core_apps.users.managers import UserManager

class UsernameValidator(validators.RegexValidator):
    """
    This validator is provided as it is from django.
    Here it can be extended further if needed.
    """
    regex = r"^[\w.@+-]+\Z"
    message = _(
        "Your username is not valid. A username can only contain letters, numbers, a dot, "
        "@ symbol, + symbols and a hypen "
    )
    # No additional features is used regex as defaults.
    flag = 0


class User(AbstractUser):
    pkid = models.BigAutoField(primary_key=True, editable=False)
    id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    first_name = models.CharField(verbose_name=_("First Name"), max_length=60)
    last_name = models.CharField(verbose_name=_("Last Name"), max_length=60)
    email = models.EmailField(verbose_name=_("Email Address"), unique=True, db_index=True)
    username = models.CharField(verbose_name=_("Username"), max_length=60, unique=True, validators=[UsernameValidator])


    EMAIL_FILED = "email"
    USERNAME_FIELD = "email"

    REQUIRED_FIELDS = ["username", "first_name", "last_name"]

    # objects is a special declaration that will represent Managets.
    # This is instance of the Manager class.
    # When we set this object to the custom user manager, the default
    # manager is being overwirtten.
    objects = UserManager()

    class Meta:
        # Inherit from the AbstractUser class.
        verbose_name = _("User")
        verbose_name_plural = _("Users")
        ordering = ["-date_joined"]


    @property
    def get_full_name(self) -> str:
        """
        This decorator is used to make this method a
        property of the User model.
        called: user.get_full_name
        instead of calling user.get_full_name()
        """
        full_name = f"{self.first_name} {self.last_name}"
        return full_name.strip()
