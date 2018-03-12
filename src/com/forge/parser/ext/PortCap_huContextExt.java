package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_huContext;

public class PortCap_huContextExt extends AbstractBaseExt {

	public PortCap_huContextExt(PortCap_huContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_huContext getContext() {
		return (PortCap_huContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_hu());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_huContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_huContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
