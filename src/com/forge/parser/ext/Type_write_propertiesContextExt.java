package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_write_propertiesContext;

public class Type_write_propertiesContextExt extends AbstractBaseExt {

	public Type_write_propertiesContextExt(Type_write_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_write_propertiesContext getContext() {
		return (Type_write_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_write_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_write_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_write_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public boolean isWriteTrigger() {
		Type_write_propertiesContext ctx = getContext();
		if (ctx.TRIGGER() != null) {
			return true;
		}
		return false;
	}
}
