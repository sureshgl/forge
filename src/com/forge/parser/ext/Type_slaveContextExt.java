package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Type_slaveContext;

public class Type_slaveContextExt extends AbstractBaseExt {

	public Type_slaveContextExt(Type_slaveContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Type_slaveContext getContext() {
		return (Type_slaveContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).type_slave());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Type_slaveContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Type_slaveContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
