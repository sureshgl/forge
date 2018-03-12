package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_read_propertiesContext;

public class Type_read_propertiesContextExt extends AbstractBaseExt {

	public Type_read_propertiesContextExt(Type_read_propertiesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_read_propertiesContext getContext() {
		return (Type_read_propertiesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_read_properties());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_read_propertiesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Type_read_propertiesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public boolean isReadTrigger() {
		Type_read_propertiesContext ctx = getContext();
		if (ctx.TRIGGER() != null) {
			return true;
		}
		return false;
	}

	@Override
	public boolean isReadClear() {
		Type_read_propertiesContext ctx = getContext();
		if (ctx.CLEAR() != null) {
			return true;
		}
		return false;
	}
}
