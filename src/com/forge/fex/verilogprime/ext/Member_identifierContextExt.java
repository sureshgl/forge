package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Member_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Member_identifierContextExt extends AbstractBaseExt {

	public Member_identifierContextExt(Member_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Member_identifierContext getContext() {
		return (Member_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).member_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Member_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Member_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}